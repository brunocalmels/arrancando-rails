json.extract! publicacion,
              :id,
              :titulo,
              :cuerpo,
              :puntajes,
              :ciudad_id,
              :created_at,
              :updated_at
json.url publicacion_url(publicacion,
                         format: :json)
