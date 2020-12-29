Rails.application.routes.draw do
  get "seguimientos/:uid/seguidos", to: "seguimientos#seguidos"
  get "seguimientos/:uid/seguidores", to: "seguimientos#seguidores"
  resources :seguimientos

  get "/notificaciones/unread", to: "notificaciones#unread"
  post "/notificaciones/mark_all_as_read", to: "notificaciones#mark_all_as_read"
  put "/notificaciones/:id", to: "notificaciones#update"

  resources :notificaciones, only: %i[new index create]
  get "app-version", to: "application#app_version"

  get "content", to: "content#index"
  get "content/saved", to: "content#saved"
  post "content/shared_this", to: "content#shared_this"
  get "content/count", to: "content#count"

  post "apple-login", to: "users#apple_client"
  post "new-google-login", to: "users#new_google_client"
  get "google-login", to: "users#google_client"
  post "new-facebook-login", to: "users#new_facebook_client"
  get "facebook-login", to: "users#facebook_client"

  get "users/usernames", to: "users#usernames"
  get "users/by_username", to: "users#by_username"
  put "users/set_firebase_token", to: "users#set_firebase_token"
  post "users/migrate_items", to: "users#migrate_items"

  resources :users
  post :avatar, to: "users#set_avatar"
  get "login", to: "users#login"
  post "authenticate", to: "authentication#authenticate"
  delete "deauthenticate", to: "authentication#deauthenticate"

  put "recetas/:id/puntuar", to: "recetas#puntuar"
  put "recetas/:id/saved", to: "recetas#saved"
  get "recetas/search", to: "recetas#search"
  resources :recetas

  put "publicaciones/:id/puntuar", to: "publicaciones#puntuar"
  put "publicaciones/:id/saved", to: "publicaciones#saved"
  get "publicaciones/search", to: "publicaciones#search"
  resources :publicaciones

  put "pois/:id/puntuar", to: "pois#puntuar"
  put "pois/:id/saved", to: "pois#saved"
  get "pois/search", to: "pois#search"
  resources :pois

  put "comentario_pois/:id/puntuar", to: "comentario_pois#puntuar"
  put "comentario_recetas/:id/puntuar", to: "comentario_recetas#puntuar"
  put "comentario_publicaciones/:id/puntuar", to: "comentario_publicaciones#puntuar"

  resources :comentario_pois
  resources :comentario_recetas
  resources :comentario_publicaciones

  get "ingredientes/search", to: "ingredientes#search"
  resources :ingredientes
  get :unidades_ingredientes, to: "unidades#index"
  resources :unidades, only: %i[new index create]

  resources :categoria_pois, except: [:show]
  resources :categoria_recetas, except: [:show]
  resources :subcategoria_recetas, except: %i[show]
  resources :categoria_publicaciones, except: [:show]

  post "contacto", to: "home#contacto"
  resources :reportes, only: %i[index show]

  get "ciudades/search", to: "ciudades#search"
  get "ciudades/importacion_masiva", to: "ciudades#new_importacion_masiva"
  post "ciudades/importacion_masiva", to: "ciudades#importacion_masiva"
  resources :ciudades
  resources :provincias, except: %i[show]
  resources :paises, except: %i[show]

  # post "/mensaje_chats", to: "mensaje_chats#create"
  resources :grupo_chats, only: %i[show]

  get :docs, to: "home#docs"

  # mount ActionCable.server => "/cable"

  root to: "home#index"
end
