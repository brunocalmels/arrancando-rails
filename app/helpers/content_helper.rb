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
      img.purge if params["remove_imagenes"].include? rails_blob_path(img)
    end
  end
end
