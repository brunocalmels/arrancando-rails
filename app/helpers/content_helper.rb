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

  def remove_imagenes(obj)
    obj.imagenes.attachments.map do |img|
      img.purge if
        params["remove_imagenes"].include?(rails_blob_path(img)) || # JSON
        params["remove_imagenes"].values.include?(rails_blob_path(img)) # HTML
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
end
