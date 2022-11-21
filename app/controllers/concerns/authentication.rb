module Authentication
  extend ActiveSupport::Concern

  included do
    # Antes de cualquier acción, se llama a este método
    before_action :set_current_user 

    private

    def set_current_user
      # Busca al usuario por id y si no lo encuentra no lanza excepción
      # Atributo disponible a toda la aplicación
      # Solo se realiza si existe una sesión
      # Lo almacena como usuario actual
      if session[:user_role] == "client"
        Current.user = User.find_by(id: session[:user_id]) if session[:user_id] 
        Current.role = Current.user.role? if session[:user_role] 
      else
        Current.user = SuperUser.find_by(id: session[:user_id]) if session[:user_id] 
        Current.role = Current.user.role? if session[:user_role] 
      end
    end

  end
end