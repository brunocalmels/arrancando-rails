cp = comentario_poi

json.extract! cp,
              :id,
              :poi_id,
              :user_id,
              :mensaje,
              :created_at,
              :updated_at

has_avatar = cp.user.avatar.attached?

json.user cp.user.as_json.merge(
  "avatar" =>
  has_avatar ? rails_blob_path(cp.user.avatar) : nil
)

json.puntajes do
  json.array! cp.my_puntajes
end

json.url comentario_poi_url(cp, format: :json)
