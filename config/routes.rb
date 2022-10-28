Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html


  # Defines the root path route ("/")
  # root "articles#index"

  # Se quiere organizar grupos de controllers bajo un namespace
  # El directorio de ellos se encuentra en app/controllers/authentication
  # Ver CAP 2.6 guides.rubyonrails.org/routing.html

  # No se quiere que el namespace figure en la ruta, entonces se pasa vacio al path
  # Sino figuraria cómo /authentication/users/new 
  namespace :authentication, path: "", as: "" do
    resources :users, only: [:new, :create]
  end
end
