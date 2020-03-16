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

if poi.imagenes.attached?
  @imgs = poi.imagenes.attachments.map do |img|
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

json.thumbnail generate_thumb(poi)

has_avatar = poi.user.avatar.attached?

json.user poi.user.as_json.merge(
  "avatar" => has_avatar ? rails_blob_path(poi.user.avatar) : nil
)

json.url poi_url(poi,
                 format: :json)
