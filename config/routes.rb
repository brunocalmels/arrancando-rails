Rails.application.routes.draw do
  resources :users
  post "authenticate", to: "authentication#authenticate"
  get "recetas/search", to: "recetas#search"
  resources :recetas
  get "publicaciones/search", to: "publicaciones#search"
  resources :publicaciones
  get "pois/search", to: "pois#search"
  resources :pois
  get "/", to: "home#index"
end
