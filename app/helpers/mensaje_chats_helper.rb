module MensajeChatsHelper
  include ContentHelper

  def to_broadcast(msj)
    user = msj.user
    has_avatar = user.avatar.attached?
    avatar = if has_avatar
               Rails.application.routes.url_helpers.rails_blob_path(
                 user.avatar,
                 only_path: true
               )
             else
               "/images/unknown.png"
             end

    Hash(
      id: msj.id,
      grupo_chat_id: msj.grupo_chat.id,
      usuario: {
        id: user.id,
        avatar: avatar,
        username: user.username
      },
      created_at: msj.created_at,
      updated_at: msj.updated_at,
      mensaje: msj.mensaje
    )
  end

  def mensaje_chat_params
    params.require(:mensaje_chat).permit(:mensaje, :grupo_chat_id)
  end

  def notificar_mencionados_en_mensaje(current_user, mensaje, grupo)
    mencionados = get_mencionados(mensaje, comentario: true)

    return if mencionados.empty?

    mencionados.each do |user|
      nueva_mencion_en_mensaje(current_user, mensaje, user, grupo)
    end
  end
end
