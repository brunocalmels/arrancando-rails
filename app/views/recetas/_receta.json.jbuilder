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
  "avatar" => has_avatar ? rails_blob_path(receta.user.avatar) : nil,
)

json.comentarios do
  json.array! receta.comentarios,
              partial: "comentario_recetas/comentario_receta.json",
              as: :comentario_receta
end

json.url receta_url(receta, format: :json)
