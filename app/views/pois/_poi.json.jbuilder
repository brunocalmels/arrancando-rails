json.extract! poi,
              :id,
              :titulo,
              :cuerpo,
              # :lat,
              # :long,
              # :puntaje,
              :direccion,
              :created_at,
              :updated_at

@puntajes = poi.puntajes.map do |k, v|
  { usuario: { id: k.to_i }, puntaje: v }
end

json.puntajes do
  json.array! @puntajes
end

json.latitud poi.lat
json.longitud poi.long

if poi.imagenes.attached?
  @imgs = poi.imagenes.attachments.map do |img|
    rails_blob_path(img)
  end
  json.imagenes do
    json.array! @imgs
  end
else
  json.imagenes ["/images/#{%w[missing missing2 missing3].sample}.jpg"]
end

json.url poi_url(poi,
                 format: :json)
