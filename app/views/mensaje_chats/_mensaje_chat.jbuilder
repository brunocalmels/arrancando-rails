json.extract! mensaje_chat,
              :id,
              :mensaje,
              :created_at

user = mensaje_chat.user
has_avatar = user.avatar.attached?
avatar = if has_avatar
           Rails.application.routes.url_helpers.rails_blob_path(
             user.avatar,
             only_path: true
           )
         else
           "/images/unknown.png"
         end

usuario = {
  id: user.id,
  avatar: avatar,
  username: user.username
}

json.usuario usuario
