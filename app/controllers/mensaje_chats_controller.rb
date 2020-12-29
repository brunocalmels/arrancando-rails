class MensajeChatsController < ApplicationController
  def create
    @mensaje_chat = MensajeChat.new(mensaje_chat_params)
    @mensaje_chat.user = current_user
    if @mensaje_chat.save
      ActionCable.server.broadcast(
        "grupo_chat_#{@mensaje_chat.grupo_chat.id}",
        to_broadcast(@mensaje_chat)
      )

      render json: nil, status: :created
    else
      render json: @mensaje_chat.errors, status: :unprocessable_entity
    end
  end

  private

  def mensaje_chat_params
    params.require(:mensaje_chat).permit(:mensaje, :grupo_chat_id)
  end

  def to_broadcast(msj)
    user = msj.user
    has_avatar = user.avatar.attached?
    avatar = has_avatar ? rails_blob_path(user.avatar) : "/images/unknown.png"

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
end
