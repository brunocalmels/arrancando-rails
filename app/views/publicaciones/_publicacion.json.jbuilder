json.extract! publicacion,
              :id,
              :titulo,
              :cuerpo,
              # :puntajes,
              :ciudad_id,
              :created_at,
              :updated_at

json.puntajes do
  json.array! publicacion.my_puntajes
end

if publicacion.imagenes.attached?
  @imgs = publicacion.imagenes.attachments.map do |img|
    rails_blob_path(img)
  end
  json.imagenes do
    json.array! @imgs
  end
else
  # json.imagenes ["/images/#{%w[missing missing2 missing3].sample}.jpg"]
  json.imagenes []
end

has_avatar = publicacion.user.avatar.attached?

json.user publicacion.user.as_json.merge(
  "avatar" =>
  has_avatar ? rails_blob_path(publicacion.user.avatar) : nil
)

json.url publicacion_url(publicacion,
                         format: :json)
