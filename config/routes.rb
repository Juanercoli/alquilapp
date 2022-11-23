Rails.application.routes.draw do
  resources :cars do 
    member do
      put :logic_delete
    end
  end
  
  # Existe una jerarquia top-down

  # Se quiere organizar grupos de controllers bajo un namespace
  # El directorio de ellos se encuentra en app/controllers/authentication
  # Ver CAP 2.6 guides.rubyonrails.org/routing.html
  # No se quiere que el namespace figure en la ruta, entonces se pasa vacio al path
  # Sino figuraria cómo /authentication/users/new 
  namespace :authentication, path: "", as: "" do
    resources :super_users, only: [:index, :new, :create]
    resources :users, only: [:new, :create], path: '/register', path_names: { new: '/' }
    resources :sessions, only: [:new, :create, :destroy], path: '/login', path_names: { new: '/' }
  end

  resources :main, only: [:index]
  

  namespace :wallet_managment, path: "", as:"" do
    resources :wallets, only: [:show] 
    put 'wallets(/:id)' , to: 'wallets#cargar_saldo'
  end
  
  # La ruta principal es:
  root "main#index"

end
