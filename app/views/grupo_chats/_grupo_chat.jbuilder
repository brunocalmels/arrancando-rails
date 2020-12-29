json.extract! grupo_chat,
              :id,
              :nombre,
              :simbolo,
              :color

json.mensajes do
  json.array! @mensajes
end
