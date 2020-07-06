json.extract! user, :id, :created_at, :updated_at, :url_instagram
json.url user_url(user, format: :json)
