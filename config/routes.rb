Rails.application.routes.draw do
  resources :cars do 
    member do
      put :visible
    end
  end
  # Reportes
  resources :reports
  patch '/reports/:id/reject', to: 'reports#reject', as: '/reject/report'
  patch '/reports/:id/accept', to: 'reports#accept', as: '/accept/report'
  
  ##get '/reports/:id/create_report_message', to: 'reports#create_report_message', as: '/create_report_message/report'
  

  resources :cars_usage_histories,only: [:show], path: '/history', path_names: { show: '/' }
  # Existe una jerarquia top-down

  # Se quiere organizar grupos de controllers bajo un namespace
  # El directorio de ellos se encuentra en app/controllers/authentication
  # Ver CAP 2.6 guides.rubyonrails.org/routing.html
  # No se quiere que el namespace figure en la ruta, entonces se pasa vacio al path
  # Sino figuraria cómo /authentication/users/new 
  namespace :authentication, path: "", as: "" do
    # Super usuarios
    resources :super_users, only: [:index, :new, :create, :edit, :update, :show]
    patch '/super_users/:id/block', to: 'super_users#block', as: '/block/supervisor'
    delete '/super_users/:id/delete', to: 'super_users#destroy', as: '/delete/supervisor'

    # Usuarios
    resources :users, only: [:edit, :update]
    resources :users, only: [:new, :create], path: '/register', path_names: { new: '/' }
    get '/users', to: 'users#index', as: '/clients'
    get '/pre_registered', to: 'users#pre_registered', as: '/pre_registered'
    patch '/users/:id/block', to: 'users#block', as: '/block/client'
    delete '/users/:id/delete', to: 'users#destroy', as: '/delete/client'
    patch '/users/:id/accept', to: 'users#accept', as: '/accept/client'
    delete '/users/:id/reject', to: 'users#reject', as: '/reject/client'
    get '/users/:id/edit_password', to: 'users#edit_password', as: '/edit_password/user'
    patch '/users/:id/edit_password', to: 'users#update_password', as: '/update_password/user'
    get '/users/:id/edit_license', to: 'users#edit_license', as: '/edit_license/user'
    patch '/users/:id/edit_license', to: 'users#update_license', as: '/update_license/user'
    patch '/users/:id/accept_license', to: 'users#accept_license', as: '/accept_license/user'
    patch '/users/:id/reject_license', to: 'users#reject_license', as: '/reject_license/user'
    get '/users/:id/reject_message', to: 'users#reject_message', as: '/reject_message/client'
    get '/users/:id/show', to: 'users#show', as: '/show/client'
    
    # Sesiones
    resources :sessions, only: [:new, :create, :destroy], path: '/login', path_names: { new: '/' }
  end

  resources :main, only: [:index]
  

  #ruteo de la wallet management
  namespace :wallet_management, path: "", as:"" do
    resources :wallets, only: [:show] 
    put 'wallets(/:id)' , to: 'wallets#cargar_saldo'
    get 'wallets(/:id)' , to: 'wallets#show'
    resources :cards
  end

  get 'rentals/new(/:id)' , to: 'rentals#new' ,as: '/new/rental'
  get 'rentals/find_car(/:id)', to: 'rentals#find_car' ,as: "/find_car"
  get 'rentals/car_tracking(/:id)', to: 'rentals#car_tracking' ,as: "/car_tracking"
  post 'rentals/find_car(/:id)', to: 'rentals#car_unlock'
  #path 'rentals/edit_rental_path(/:id)', to: 'rentals#update'
  #post'rentals/car_tracking(/:id)', to: 'rentals#finish_trip'
  resources :rentals
  
  
  # La ruta principal es:
  root "main#index"


  
end
