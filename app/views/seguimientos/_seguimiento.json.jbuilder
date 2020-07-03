json.extract! seguimiento,
              :id,
              :seguidor_id,
              :seguido_id,
              :created_at,
              :updated_at
json.url seguimiento_url(seguimiento, format: :json)
