class Authentication::SessionsController < ApplicationController
  def new
  end
  
  def create
    @user = User.find_by("dni = :login OR email = :login", {login: params[:login] })
    pp @user

    # Comprueba la contraseña que enviamos desde el form con la que está en DB
    if @user&.authenticate(params[:password])
      redirect_to users_path, notice: t('.created')
    else 
      redirect_to new_session_path, alert: t('.failed')
    end
  end

  private
  def user_params
    # Se quiere que tenga un objeto User antes que todo el contenido de parámetros
    # Luego se hace el permit con todo lo que debe tener
    params.require(:user).permit(:dni, :name, :surname, :email, :phone, :password, :driver_license, :driver_license_expiration, :birthdate)
  end
end 