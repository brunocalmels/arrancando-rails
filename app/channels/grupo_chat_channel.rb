class GrupoChatChannel < ApplicationCable::Channel
  def subscribed
    @grupo_chat = GrupoChat.find params[:grupo_chat_id]
    stream_from stream_name
    ActionCable.server.broadcast(
      "grupo_chat_#{@grupo_chat.id}",
      type: "Mensaje grupal",
      mensaje: "@#{user.username} ha entrado a la sala."
    )
  end

  def receive(data)
    ActionCable.server.broadcast stream_name, data.fetch("message")
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
