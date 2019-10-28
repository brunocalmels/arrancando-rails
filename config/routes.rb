Rails.application.routes.draw do
  resources :users
  get "recetas/search", to: "recetas#search"
  resources :recetas
  get "publicaciones/search", to: "publicaciones#search"
  resources :publicaciones
  post "authenticate", to: "authentication#authenticate"
  get "/", to: "home#index"
end
