cr = comentario_receta

json.extract! cr,
              :id,
              :receta_id,
              :user_id,
              :mensaje,
              :created_at,
              :updated_at

has_avatar = cr.user.avatar.attached?

json.user cr.user.as_json.merge(
  "avatar" =>
  has_avatar ? rails_blob_path(cr.user.avatar) : nil
)

json.url comentario_receta_url(cr, format: :json)
