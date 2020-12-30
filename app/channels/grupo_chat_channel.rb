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

    lista_usuarios = Rails.cache.read(
      "#{stream_name}_user_list"
    ) || []

    lista_usuarios += [user.id]

    Rails.cache.write(
      "#{stream_name}_user_list",
      lista_usuarios
    )

    broadcast_cantidad_usuarios(lista_usuarios)
  end

  def unsubscribed
    @grupo_chat = GrupoChat.find params[:grupo_chat_id]
    ActionCable.server.broadcast(
      stream_name,
      type: "Mensaje grupal",
      mensaje: "@#{user.username} ha salido de la sala."
    )

    lista_usuarios = Rails.cache.read(
      "#{stream_name}_user_list"
    ) || []

    lista_usuarios.delete user.id

    Rails.cache.write(
      "#{stream_name}_user_list",
      lista_usuarios
    )

    broadcast_cantidad_usuarios(lista_usuarios)
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
      mensaje: cantidad.uniq.count.to_s
    )
  end
end
