json.extract! publicacion,
              :id,
              :titulo,
              :cuerpo,
              # :puntajes,
              :ciudad_id,
              :created_at,
              :updated_at

@puntajes = publicacion.puntajes.map do |k, v|
  { usuario: { id: k.to_i }, puntaje: v }
end

json.puntajes do
  json.array! @puntajes
end

if publicacion.imagenes.attached?
  @imgs = publicacion.imagenes.attachments.map do |img|
    rails_blob_path(img)
  end
  json.imagenes do
    json.array! @imgs
  end
else
  json.imagenes ["/images/#{%w[missing missing2 missing3].sample}.jpg"]
end

json.user publicacion.user

json.url publicacion_url(publicacion,
                         format: :json)
