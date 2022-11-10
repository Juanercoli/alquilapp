class Authentication::SessionsController < ApplicationController
  skip_before_action :protect_pages # Callback que skipeo

  def new
  end
  
  def create
    #@user = SuperUser.find_by(dni o email) sino
    @user = User.find_by("dni = :login", {login: params[:login] })
    pp @user&.instance_of? User

    # Establece cuando un usuario es válido
    valid_user = @user&.is_valid? params[:password]

    # Comprueba la contraseña que enviamos desde el form con la que está en DB
    # Se usa el authenticate porque está encriptado
    # El & es para decir: si user es nil entonces retorno falso
    if valid_user.nil?
      pp "NIL INVALIDO"
      # El usuario es invalido porque no existe
      redirect_to new_session_path, alert: t('.failed_not_exists') 
    elsif valid_user
      # Cuando el usuario se autentica también creamos la sesión
      session[:user_id] = @user.id
      redirect_to main_index_path, notice: t('.created')
    elsif @user&.isBlocked
      # Si el usuario esta bloqueado del sistema
      redirect_to new_session_path, alert: t('.failed_is_blocked')      
    elsif !(@user&.isAccepted)
      # Si el usuario esta en lista de pre-registro
      pp "NO ACEPTADO"
      pp (@user&.isAccepted)
      redirect_to new_session_path, alert: t('.failed_not_accepted')
    else
      pp "INVALIDO"
      # El usuario es invalido porque introdujo mal los datos
      redirect_to new_session_path, alert: t('.failed_not_valid') 
    end
  end

  def destroy
    # Permite destruir la cookie sesión
    session.delete(:user_id)

    redirect_to main_index_path, notice: t('.destroyed')
  end

  private
  def user_params
    # Se quiere que tenga un objeto User antes que todo el contenido de parámetros
    # Luego se hace el permit con todo lo que debe tener
    params.require(:user).permit(:dni, :name, :surname, :email, :phone, :password, :driver_license, :driver_license_expiration, :birthdate)
  end
end 