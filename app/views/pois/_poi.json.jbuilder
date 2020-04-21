json.extract! poi,
              :id,
              :titulo,
              :cuerpo,
              # :lat,
              # :long,
              # :puntaje,
              :categoria_poi_id,
              :direccion,
              :created_at,
              :updated_at

json.puntajes do
  json.array! poi.my_puntajes
end

json.latitud poi.lat
json.longitud poi.long

video_thumbs = {}

if poi.imagenes.attached?
  @imgs = poi.imagenes.attachments.map do |img|
    url = asset_url_for(img, device: "app")
    case img.blob.content_type
    when "video/mp4", "video/mpg", "video/mpeg"
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

json.thumbnail generate_thumb(poi)

json.video_thumbs video_thumbs

has_avatar = poi.user.avatar.attached?

# rubocop: disable Metrics/LineLength

json.user poi.user.as_json.merge(
  "avatar" => has_avatar ? rails_blob_path(poi.user.avatar) : "/images/unknown.png"
)

# rubocop: enable Metrics/LineLength

json.url poi_url(poi,
                 format: :json)
