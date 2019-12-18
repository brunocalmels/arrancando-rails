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
    # url_for(img)
    url_for(img.variant(
              resize_to_limit: [MAX_IMAGE_WIDTH_APP, MAX_IMAGE_HEIGHT_APP]
            ))
  end
  json.imagenes do
    json.array! @imgs
  end
else
  json.imagenes []
end

has_avatar = publicacion.user.avatar.attached?

json.user publicacion.user.as_json.merge(
  "avatar" => has_avatar ? rails_blob_path(publicacion.user.avatar) : nil
)

json.comentarios do
  json.array! publicacion.comentarios,
              partial: "comentario_publicaciones/comentario_publicacion",
              as: :comentario_publicacion
end

json.url publicacion_url(publicacion,
                         format: :json)
