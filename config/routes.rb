Rails.application.routes.draw do
  get "app-version", to: "application#app_version"

  get "content", to: "content#index"
  get "content/saved", to: "content#saved"

  post "apple-login", to: "users#apple_client"
  post "new-google-login", to: "users#new_google_client"
  get "google-login", to: "users#google_client"
  get "facebook-login", to: "users#facebook_client"

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

  resources :comentario_recetas
  resources :comentario_publicaciones

  resources :ingredientes
  get "ingredientes/search", to: "ingredientes#search"

  resources :categoria_pois, except: [:show]
  resources :categoria_recetas, except: [:show]
  resources :subcategoria_recetas, except: %i[show new create]
  resources :categoria_publicaciones, except: [:show]

  post "contacto", to: "home#contacto"
  resources :reportes, only: %i[index show]

  get "ciudades/search", to: "ciudades#search"
  get "ciudades/importacion_masiva", to: "ciudades#new_importacion_masiva"
  post "ciudades/importacion_masiva", to: "ciudades#importacion_masiva"
  resources :ciudades
  resources :provincias, except: %i[show]
  resources :paises, except: %i[show]

  get :docs, to: "home#docs"
  # get :android, to: "home#android"

  root to: "home#index"
end
