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
              :updated_at,
              :duracion,
              :complejidad,
              :habilitado

json.puntajes do
  json.array! receta.my_puntajes
end

json.subcategoria_recetas do
  json.array! receta.subcategoria_recetas
end

json.ingredientes_items do
  json.array! receta.ingredientes_items
end

video_thumbs = {}

if receta.imagenes.attached?
  @imgs = receta.imagenes.attachments.map do |img|
    url = asset_url_for(img, device: "app")
    case img.blob.content_type
    when "video/mp4", "video/mpg", "video/mpeg", "video/quicktime"
      video_thumbs[url] = generate_video_thumb(img)
    end
    url
  end
  json.imagenes do
    json.array! @imgs
  end
else
  # json.imagenes ["/images/#{%w[missing missing2 missing3].sample}.jpg"]
  json.imagenes []
end

json.thumbnail generate_thumb(receta)

json.video_thumbs video_thumbs

has_avatar = receta.user.avatar.attached?

# rubocop: disable Metrics/LineLength

json.user receta.user.as_json.merge(
  "avatar" => has_avatar ? rails_blob_path(receta.user.avatar) : "/images/unknown.png"
)

# rubocop: enable Metrics/LineLength

json.comentarios do
  json.array! receta.comentarios,
              partial: "comentario_recetas/comentario_receta.json",
              as: :comentario_receta
end

seguimiento = Seguimiento.where(
  seguidor_id: @current_user.id,
  seguido_id: receta.user.id
).first

json.seguido seguimiento.nil? ? nil : seguimiento.id

json.color publicacion.likes_color

json.url receta_url(receta, format: :json)
