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
     params["remove_imagenes"].include?(rails_blob_path(img)))
  end

  def purge_images_html(params, img)
    (!params["remove_imagenes"].nil? &&
     params["remove_imagenes"].class == ActionController::Parameters &&
     params["remove_imagenes"].values.include?(rails_blob_path(img)))
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
    ActionDispatch::Http::UploadedFile.new(
      tempfile: tempfile(img["data"]),
      filename: img["file"],
      type: Mime::Type.lookup_by_extension(
        File.extname(img["file"])[1..-1]
      ).to_s
    )
  end

  def save_images_json(params, obj)
    params[:imagenes].each do |img|
      obj.imagenes.attach(
        build_base64_img(img)
      )
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
end
