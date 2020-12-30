class GrupoChatChannel < ApplicationCable::Channel
  include MensajeChatsHelper

  def subscribed
    @grupo_chat = GrupoChat.find params[:grupo_chat_id]
    stream_from stream_name
    ActionCable.server.broadcast(
      stream_name,
      type: "Mensaje grupal",
      mensaje: "@#{user.username} ha entrado a la sala."
    )
    @cantidad_usuarios ||= {}
    @cantidad_usuarios[stream_name] = @cantidad_usuarios[stream_name] || 0
    @cantidad_usuarios[stream_name] = @cantidad_usuarios[stream_name] + 1

    broadcast_cantidad_usuarios(@cantidad_usuarios[stream_name])
  end

  def unsubscribed
    @grupo_chat = GrupoChat.find params[:grupo_chat_id]
    ActionCable.server.broadcast(
      stream_name,
      type: "Mensaje grupal",
      mensaje: "@#{user.username} ha salido de la sala."
    )
    @cantidad_usuarios[stream_name] =
      @cantidad_usuarios[stream_name] - 1
    @cantidad_usuarios[stream_name] =
      @cantidad_usuarios[stream_name] < 0 ? 0 : @cantidad_usuarios[stream_name]

    broadcast_cantidad_usuarios(@cantidad_usuarios[stream_name])
  end

  def receive(data)
    grupo = GrupoChat.find(JSON(identifier)["grupo_chat_id"].to_i)

    return unless grupo

    @mensaje_chat = MensajeChat.new(
      mensaje: data.fetch("mensaje"),
      grupo_chat: grupo
    )
    @mensaje_chat.user = user
    return unless @mensaje_chat.save

    notificar_mencionados_en_mensaje(user, @mensaje_chat, grupo)

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

  def broadcast_cantidad_usuarios(cantidad)
    ActionCable.server.broadcast(
      stream_name,
      type: "Cantidad usuarios",
      mensaje: cantidad.to_s
    )
  end
end
