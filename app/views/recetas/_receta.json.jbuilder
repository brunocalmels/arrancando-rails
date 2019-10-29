json.extract! receta,
              :id,
              :titulo,
              :cuerpo,
              :puntaje,
              :categoria_receta_id,
              :created_at,
              :updated_at
json.url receta_url(receta, format: :json)
