json.extract! publicacion,
              :id,
              :titulo,
              :cuerpo,
              :puntajes,
              :ciudad_id,
              :created_at,
              :updated_at

if publicacion.imagenes.attached?
  @imgs = publicacion.imagenes.attachments.map do |img|
    rails_blob_path(img)
  end
  json.imagenes do
    json.array! @imgs
  end
else
  json.imagenes "/images/missing.jpg"
end

json.url publicacion_url(publicacion,
                         format: :json)
