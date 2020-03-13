Rails.application.routes.draw do
  get "app-version", to: "application#app_version"
  resources :comentario_recetas
  resources :comentario_publicaciones
  get "google-login", to: "users#google_client"
  get "facebook-login", to: "users#facebook_client"
  get "content", to: "content#index"
  get "content/saved", to: "content#saved"
  resources :users
  post :avatar, to: "users#set_avatar"
  get "login", to: "users#login"
  post "authenticate", to: "authentication#authenticate"
  delete "deauthenticate", to: "authentication#deauthenticate"
  put "recetas/:id/puntuar", to: "recetas#puntuar"
  get "recetas/search", to: "recetas#search"
  resources :recetas
  put "publicaciones/:id/puntuar", to: "publicaciones#puntuar"
  get "publicaciones/search", to: "publicaciones#search"
  resources :publicaciones
  put "pois/:id/puntuar", to: "pois#puntuar"
  get "pois/search", to: "pois#search"
  resources :pois
  get "ciudades/search", to: "ciudades#search"
  resources :ciudades, except: %i[show destroy]
  resources :categoria_pois, except: [:show]
  resources :categoria_recetas, except: [:show]
  resources :categoria_publicaciones, except: [:show]
  post "contacto", to: "home#contacto"
  resources :reportes, only: %i[index show]
  get :docs, to: "home#docs"
  root to: "home#index"
end
