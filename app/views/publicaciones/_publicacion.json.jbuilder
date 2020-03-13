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
    asset_url_for(img, device: "app")
    # FIXME: Testear
    # case img.blob.content_type
    # when "video/mp4", "video/mpg", "video/mpeg"
    #   url_for(img)
    # when "image/jpg", "image/jpeg", "image/png"
    #   url_for(img.variant(
    #             resize_to_limit: [MAX_IMAGE_WIDTH_APP, MAX_IMAGE_HEIGHT_APP]
    #           ))
    # end
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
