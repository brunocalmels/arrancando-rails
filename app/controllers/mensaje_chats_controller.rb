class MensajeChatsController < ApplicationController
  # def create
  #   @mensaje_chat = MensajeChat.new(mensaje_chat_params)
  #   @mensaje_chat.user = current_user
  #   if @mensaje_chat.save
  #     ActionCable.server.broadcast(
  #       "grupo_chat_#{@mensaje_chat.grupo_chat.id}",
  #       to_broadcast(@mensaje_chat)
  #     )

  #     render json: nil, status: :created
  #   else
  #     render json: @mensaje_chat.errors, status: :unprocessable_entity
  #   end
  # end
end
