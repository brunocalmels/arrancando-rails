json.extract! receta,
              :id,
              :titulo,
              :cuerpo,
              :introduccion,
              :ingredientes,
              :instrucciones,
              # :puntaje,
              :categoria_receta_id,
              :created_at,
              :updated_at

json.puntajes do
  json.array! receta.my_puntajes
end

if receta.imagenes.attached?
  @imgs = receta.imagenes.attachments.map do |img|
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
  # json.imagenes ["/images/#{%w[missing missing2 missing3].sample}.jpg"]
  json.imagenes []
end

json.thumbnail generate_thumb(receta)

has_avatar = receta.user.avatar.attached?

json.user receta.user.as_json.merge(
  "avatar" => has_avatar ? rails_blob_path(receta.user.avatar) : nil
)

json.comentarios do
  json.array! receta.comentarios,
              partial: "comentario_recetas/comentario_receta.json",
              as: :comentario_receta
end

json.url receta_url(receta, format: :json)
