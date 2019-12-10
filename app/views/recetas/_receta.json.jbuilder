json.extract! receta,
              :id,
              :titulo,
              :cuerpo,
              # :puntaje,
              :categoria_receta_id,
              :created_at,
              :updated_at

json.puntajes do
  json.array! receta.my_puntajes
end

if receta.imagenes.attached?
  @imgs = receta.imagenes.attachments.map do |img|
    rails_blob_path(img)
  end
  json.imagenes do
    json.array! @imgs
  end
else
  # json.imagenes ["/images/#{%w[missing missing2 missing3].sample}.jpg"]
  json.imagenes []
end

json.user receta.user

json.url receta_url(receta, format: :json)
