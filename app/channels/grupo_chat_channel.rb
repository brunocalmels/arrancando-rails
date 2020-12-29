class GrupoChatChannel < ApplicationCable::Channel
  include MensajeChatsHelper

  def subscribed
    @grupo_chat = GrupoChat.find params[:grupo_chat_id]
    stream_from stream_name
    ActionCable.server.broadcast(
      "grupo_chat_#{@grupo_chat.id}",
      type: "Mensaje grupal",
      mensaje: "@#{user.username} ha entrado a la sala."
    )
  end

  def unsubscribed
    @grupo_chat = GrupoChat.find params[:grupo_chat_id]
    ActionCable.server.broadcast(
      "grupo_chat_#{@grupo_chat.id}",
      type: "Mensaje grupal",
      mensaje: "@#{user.username} ha salido de la sala."
    )
  end

  def receive(data)
    @mensaje_chat = MensajeChat.new(
      mensaje: data.fetch("mensaje"),
      grupo_chat: GrupoChat.find(JSON(identifier)["grupo_chat_id"].to_i)
    )
    @mensaje_chat.user = user
    return unless @mensaje_chat.save

    ActionCable.server.broadcast(
      "grupo_chat_#{@mensaje_chat.grupo_chat.id}",
      to_broadcast(@mensaje_chat)
    )
  end

  private

  def stream_name
    "grupo_chat_#{@grupo_chat.id}"
  end

  def user
    mimic = {}
    mimic["Authorization"] = params[:token]
    AuthorizeApiRequest.call(mimic).result
  end
end
