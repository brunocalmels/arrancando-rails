# rubocop:disable Metrics/ModuleLength

module ContentHelper
  def puntuar_obj(obj)
    unless params["puntaje"]
      render(json: "Invalid data", status: :unprocessable_entity) && return
    end
    obj.puntajes[current_user.id] = params["puntaje"].to_i
    if obj.save
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
      type: mime_type
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
                resize_to_limit: [max_width, max_height]
              ))
    end
  end

  def generate_thumb(obj)
    return nil if obj.imagenes.empty?

    if obj.imagenes.first.previewable?
      url_for(obj.imagenes.first.preview(
                resize_to_limit: [THUMB_SIZE, THUMB_SIZE]
              ))
    else
      url_for(obj.imagenes.first.variant(
                resize_to_limit: [THUMB_SIZE, THUMB_SIZE]
              ))
    end
  end

  def generate_video_thumb(video)
    return unless video.previewable?

    url_for(video.preview(
              resize_to_limit: [THUMB_SIZE, THUMB_SIZE]
            ))
  end

  def get_maps_image(poi, item)
    unless item["photos"] &&
           item["photos"][0] &&
           item["photos"][0]["photo_reference"]
      return
    end

    puts "Obteniendo thumbnail"

    # rubocop:disable Metrics/LineLength

    downloaded_image = URI.parse(
      "https://maps.googleapis.com/maps/api/place/photo?photoreference=#{item['photos'][0]['photo_reference']}&sensor=false&maxheight=#{MAX_SIZE_POI_IMAGE}&maxwidth=#{MAX_SIZE_POI_IMAGE}&key=#{ENV['MAPS_API_KEY']}"
    ).open

    # rubocop:enable Metrics/LineLength

    poi.imagenes.attach(
      io: downloaded_image,
      filename: "#{poi.id}-maps-image.jpg"
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
end

# rubocop:enable Metrics/ModuleLength
