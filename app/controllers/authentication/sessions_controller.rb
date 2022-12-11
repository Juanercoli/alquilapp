class Authentication::SessionsController < ApplicationController

  def new
  end
  
  def create
    #@user = SuperUser.find_by(dni o email) sino
    @user = User.find_by("dni = :login", {login: params[:login] })
    if(@user.nil?)
      @user = SuperUser.find_by("email = :login", {login: params[:login] })
    end
    # Establece cuando un usuario es válido
    valid_user = @user&.is_valid? params[:password]

    # Comprueba la contraseña que enviamos desde el form con la que está en DB
    # Se usa el authenticate porque está encriptado
    # El & es para decir: si user es nil entonces retorno falso
    if valid_user.nil?
      # El usuario es invalido porque no existe
      redirect_to new_session_path, alert: t('.failed_not_exists') 
    elsif valid_user
      # Cuando el usuario se autentica también creamos la sesión
      if @user.driver_license_expirated?
        @user.update_attribute(:must_modify_license, true)
      end
      session[:user_id] = @user.id
      session[:user_role] = @user.role?
      redirect_to main_index_path, notice: t('.created')
    elsif @user&.is_blocked
      # Si el usuario esta bloqueado del sistema
      redirect_to new_session_path, alert: t('.failed_is_blocked')      
    else
      # El usuario es invalido porque introdujo mal los datos
      redirect_to new_session_path, alert: t('.failed_not_valid') 
    end
  end

  def destroy
    # Permite destruir la cookie sesión
    session.delete(:user_id)
    session.delete(:user_role)

    redirect_to main_index_path, notice: t('.destroyed')
  end

  private
  
  def user_params
    # Se quiere que tenga un objeto User antes que todo el contenido de parámetros
    # Luego se hace el permit con todo lo que debe tener
    params.require(:user).permit(:dni, :name, :surname, :email, :phone, :password, :driver_license, :driver_license_expiration, :birthdate)
  end

end 