Rails.application.routes.draw do
  resources :users
  post :avatar, to: "users#set_avatar"
  get "login", to: "users#login"
  post "authenticate", to: "authentication#authenticate"
  put "recetas/:id/puntuar", to: "recetas#puntuar"
  get "recetas/search", to: "recetas#search"
  resources :recetas
  put "publicaciones/:id/puntuar", to: "publicaciones#puntuar"
  get "publicaciones/search", to: "publicaciones#search"
  resources :publicaciones
  put "pois/:id/puntuar", to: "pois#puntuar"
  get "pois/search", to: "pois#search"
  resources :pois
  resources :ciudades, only: %i[index]
  resources :categoria_pois, only: %i[index]
  resources :categoria_recetas, only: %i[index]
  root to: "home#index"
end
