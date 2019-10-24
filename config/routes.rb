Rails.application.routes.draw do
  resources :users # , except: %i[show create index edit update new destroy]
  post "authenticate", to: "authentication#authenticate"
  get "/", to: "home#index"
end
