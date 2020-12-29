json.extract! grupo_chat,
              :id,
              :nombre,
              :simbolo,
              :color

json.mensajes do
  json.array! @mensajes,
              partial: "mensaje_chats/mensaje_chat",
              as: :mensaje_chat
end
