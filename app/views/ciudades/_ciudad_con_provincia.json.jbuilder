json.extract! ciudad, :id, :created_at, :updated_at, :populada

json.nombre "#{ciudad.nombre} (#{ciudad.provincia.nombre})"
# json.url ciudad_url(ciudad, format: :json)
