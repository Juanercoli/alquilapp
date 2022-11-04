class Authentication::UsersController < ApplicationController
    def new
      # Para la acción view utilizo una variable de instancia vacia
      # Esta variable de instancia vacia se va a rellenar con el formulario correspondiente
      @user = User.new
    end
    
    def create
      # Se filtran los parámetros instanciando de nuevo
      @user = User.new(user_params)

      if @user.save
      # Si el usuario se guarda correctamente
      # Y se redirige a la página principal
      #!! REDIRECCION A PAGINA PRINCIPAL
      redirect_to new_user_path, notice: t(".created")
      else
      # Sino se renderiza de nuevo el formulario new
      # Se pasa como status unprocessable_entity para que TURBO entienda que el formulario no es correcto y se vuelva a renderizar (convención de turbo)
        render :new, status: :unprocessable_entity
      end

    end

    private
    def user_params
      # Se quiere que tenga un objeto User antes que todo el contenido de parámetros
      # Luego se hace el permit con todo lo que debe tener
      params.require(:user).permit(:dni, :name, :surname, :email, :phone, :password, :driver_license_expiration, :birthdate)
    end
end 