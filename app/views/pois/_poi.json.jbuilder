json.extract! poi,
              :id,
              :titulo,
              :cuerpo,
              :lat,
              :long,
              :puntaje,
              :created_at,
              :updated_at
json.url poi_url(poi,
                 format: :json)
