json.extract! poi,
              :id,
              :titulo,
              :cuerpo,
              :lat,
              :long,
              :puntaje,
              :direccion,
              :created_at,
              :updated_at

if poi.imagenes.attached?
  @imgs = poi.imagenes.attachments.map do |img|
    rails_blob_path(img)
  end
  json.imagenes do
    json.array! @imgs
  end
else
  json.imagenes "/images/missing.jpg"
end

json.url poi_url(poi,
                 format: :json)
