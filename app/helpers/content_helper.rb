require "#{Rails.root}/app/helpers/notificaciones_helper"

module ContentHelper
  include NotificacionesHelper

  def puntuar_obj(obj)
    unless params["puntaje"]
      render(json: "Invalid data", status: :unprocessable_entity) && return
    end
    if params["puntaje"].to_i == 0
      obj.puntajes.delete(current_user.id.to_s)
    else
      obj.puntajes[current_user.id.to_s] = params["puntaje"].to_i
    end
    if obj.save
      if params["puntaje"].to_i != 0
        nueva_puntuacion(obj, params["puntaje"].to_i)
      end
      render json: nil, status: :ok
    else
      render json: "Invalid data", status: :unprocessable_entity
    end
  end

  def purge_images_json(params, img)
    (!params["remove_imagenes"].nil? &&
     params["remove_imagenes"].class == Array &&
     params["remove_imagenes"].include?(
       "/rails" + asset_url_for(img, device: "app").split("rails")[1]
     ))
  end

  def purge_images_html(params, img)
    (!params["remove_imagenes"].nil? &&
     params["remove_imagenes"].class == ActionController::Parameters &&
     params["remove_imagenes"].values.include?(
       "/rails" + asset_url_for(img).split("rails")[1]
     ))
  end

  def remove_imagenes(obj)
    obj.imagenes.attachments.map do |img|
      img.purge if
        purge_images_json(params, img) || # JSON
        purge_images_html(params, img) # HTML
    end
  end

  def tempfile(data)
    tempfile = Tempfile.new("fileupload")
    tempfile.binmode
    tempfile.write(Base64.decode64(data))
    tempfile.rewind
    tempfile
  end

  def build_base64_img(img)
    mime_type = Mime::Type.lookup_by_extension(
      File.extname(img["file"])[1..-1]
    ).to_s
    return nil unless mime_type.in?(PERMITTED_MIME_TYPES)

    ActionDispatch::Http::UploadedFile.new(
      tempfile: tempfile(img["data"]),
      filename: img["file"],
      type: mime_type,
    )
  end

  def save_images_json(params, obj)
    params[:imagenes].each do |img|
      objeto = build_base64_img(img)
      next unless objeto

      obj.imagenes.attach(objeto)
    end
    obj.valid?
  end

  def save_images_html(params, obj, tipo)
    imagenes = params[tipo][:imagenes]
    imagenes.each do |img|
      if img.content_type.split("/")[0] == "image" &&
         img.size > MIN_IMAGE_SIZE_TO_ENFORCE_COMPRESSION
        path = img.tempfile.path
        img_resized = MiniMagick::Image
          .new(path)
        img_resized = img_resized.resize \
          "#{MAX_IMAGE_WIDTH_APP}x#{MAX_IMAGE_HEIGHT_APP}"
        fi = File.open(img_resized.path)
        obj.imagenes.attach(io: fi,
                            filename: img.original_filename,
                            content_type: img.content_type)
      else
        obj.imagenes.attach img
      end
    end
    obj.valid?
  end

  def update_images_json(params, obj)
    remove_imagenes(obj) if params["remove_imagenes"]
    save_images_json(params, obj)
  end

  def update_images_html(params, obj, tipo)
    remove_imagenes(obj) if params["remove_imagenes"]
    save_images_html(params, obj, tipo) unless params[tipo][:imagenes].nil?
    true
  end

  def asset_url_for(asset, device: "web")
    case device
    when "app"
      max_width = MAX_IMAGE_WIDTH_APP
      max_height = MAX_IMAGE_HEIGHT_APP
    when "metatag"
      max_width = MAX_IMAGE_WIDTH_METATAG
      max_height = MAX_IMAGE_HEIGHT_METATAG
    else
      max_width = MAX_IMAGE_WIDTH_WEB
      max_height = MAX_IMAGE_HEIGHT_WEB
    end
    case asset.blob.content_type
    when "video/mp4", "video/mpg", "video/mpeg", "video/quicktime"
      url_for(asset)
    when "image/jpg", "image/jpeg", "image/png", "image/gif"
      url_for(asset.variant(
        resize_to_limit: [max_width, max_height],
      ).processed)
    end
  end

  def generate_thumb(obj)
    return nil if obj.imagenes.empty?

    if obj.imagenes.first.previewable?
      url_for(obj.imagenes.first.preview(
        resize_to_limit: [THUMB_SIZE, THUMB_SIZE],
      ))
    else
      url_for(obj.imagenes.first.variant(
        resize_to_limit: [THUMB_SIZE, THUMB_SIZE],
      ).processed)
    end
  end

  def generate_video_thumb(video)
    return unless video.previewable?

    url_for(video.preview(
      resize_to_limit: [THUMB_SIZE, THUMB_SIZE],
    ))
  end

  def get_maps_image(poi, item)
    unless item["photos"] &&
           item["photos"][0] &&
           item["photos"][0]["photo_reference"]
      return
    end

    puts "Obteniendo thumbnail"

    downloaded_image = URI.parse(
      "https://maps.googleapis.com/maps/api/place/photo?photoreference=#{item["photos"][0]["photo_reference"]}&sensor=false&maxheight=#{MAX_SIZE_POI_IMAGE}&maxwidth=#{MAX_SIZE_POI_IMAGE}&key=#{ENV["MAPS_API_KEY"]}"
    ).open

    poi.imagenes.attach(
      io: downloaded_image,
      filename: "#{poi.id}-maps-image.jpg",
    )
  end

  def first_image_to_share(item)
    item.imagenes.any? && item.imagenes.each_with_index do |img, _i|
      case img.blob.content_type
      when "video/mp4", "video/mpg", "video/mpeg", "video/quicktime"
        next
      when "image/jpg", "image/jpeg", "image/png", "image/gif"
        return asset_url_for(img, device: "metatag")
      end
    end
  end

  def find_users(texto)
    mencionados = []
    arrobas = texto.split(" ").filter { |p| p[0] == "@" }
    arrobas.each do |a|
      user = User.where(username: a.gsub("@", "")).first
      mencionados << user unless user.nil?
    end
    mencionados
  end

  def get_mencionados(obj, comentario: false)
    mencionados = []
    if comentario
      if obj.has_attribute?("mensaje") && !obj.mensaje.nil?
        mencionados += find_users(obj.mensaje)
      end
    else
      if obj.has_attribute?("cuerpo") && !obj.cuerpo.nil?
        mencionados += find_users(obj.cuerpo)
      end
      if obj.has_attribute?("introduccion") && !obj.introduccion.nil?
        mencionados += find_users(obj.introduccion)
      end
      if obj.has_attribute?("instrucciones") && !obj.instrucciones.nil?
        mencionados += find_users(obj.instrucciones)
      end
    end
    mencionados.uniq
  end

  def notificar_mencionados(obj, tipo, comentario: false)
    mencionados = get_mencionados(obj, comentario: comentario)

    return if mencionados.empty?

    mencionados.each do |m|
      nueva_mencion(obj, tipo, m, comentario: comentario)
    end
  end

  def likes_color_object(obj)
    get_color(
      obj.puntajes.filter do |_k, p|
        p == 5
      end.count
    )
  end

  def saved_obj(obj)
    unless params.key?(:saved)
      render(json: "Invalid data", status: :unprocessable_entity) && return
    end
    if params["saved"]
      obj.saved = obj.saved + [current_user.id.to_i]
    else
      obj.saved = obj.saved - [current_user.id.to_i]
    end

    obj.saved = obj.saved.uniq

    if obj.save
      if params["saved"]
        guardo_contenido(obj)
      end
      render json: nil, status: :ok
    else
      render json: "Invalid data", status: :unprocessable_entity
    end
  end

  def get_likes(obj)
    obj.puntajes.filter { |k, v| v == 5 }.count
  end

  def self.query_for_likes(user_id, tabla)
    "SELECT sum(cant_punt) as suma FROM ( SELECT #{tabla}.id, cant_punt FROM #{tabla} LEFT JOIN ( SELECT id, user_id, count(*) as cant_punt FROM #{tabla} LEFT JOIN jsonb_each(puntajes) d ON true WHERE (d.value :: float) = 5 GROUP BY #{tabla}.id ) complex ON #{tabla}.id = complex.id WHERE #{tabla}.user_id = #{user_id} AND cant_punt IS NOT NULL ORDER BY cant_punt DESC nulls LAST ) filtrado;"
  end

  private

  def get_color(number)
    LIKES_TO_COLOR[
      LIKES_TO_COLOR.keys
                    .filter { |k| number >= k[0] && number < k[1] }
                    .first
    ]
  end
end
