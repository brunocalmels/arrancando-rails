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

video_thumbs = {}

if publicacion.imagenes.attached?
  @imgs = publicacion.imagenes.attachments.map do |img|
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
  json.imagenes []
end

json.thumbnail generate_thumb(publicacion)

json.video_thumbs video_thumbs

has_avatar = publicacion.user.avatar.attached?

# rubocop: disable Metrics/LineLength

json.user publicacion.user.as_json.merge(
  "avatar" => has_avatar ? rails_blob_path(publicacion.user.avatar) : "/images/unknown.png"
)

# rubocop: enable Metrics/LineLength

json.comentarios do
  json.array! publicacion.comentarios,
              partial: "comentario_publicaciones/comentario_publicacion",
              as: :comentario_publicacion
end

json.url publicacion_url(publicacion,
                         format: :json)
