class Authentication::UsersController < ApplicationController

    def index
      # Usuarios activos
      @users = User.where(is_deleted: :false, is_accepted: true)
    end

    def pre_registered
      # Usuarios pre-registrados (por ser aprobados o rechazados)
      @users = User.where(is_deleted: :false, is_accepted: false)
      #TRAER TABLA DONDE IS_ACCEPTED: FALSE

        # VIEW --> BOTON APROBAR -> approve --> UserMail.approve
        # VIEW --> BOTON RECHAZAR -> reject --> UserMail.reject
    end

    def accept
      user
      @amount = 400
      user.wallet.balance = @amount
      user.update_attribute(:is_accepted, true)
      user.wallet.save
      UserMailer.with(user: user, amount: @amount).accept.deliver_later
      redirect_to pre_registered_path, notice: t('.accepted')
    end

    def reject
      # Enviar mail de por qué rechaza el pre-registro
      UserMailer.with(user: user, motive: params[:motive], observations: params[:observations]).reject.deliver_now
      user.destroy
      redirect_to pre_registered_path, notice: t('.rejected')
    end

    def new
      # Para la acción view utilizo una variable de instancia vacia
      # Esta variable de instancia vacia se va a rellenar con el formulario correspondiente
      @user = User.new
    end
    
    def create
      # Se filtran los parámetros instanciando de nuevo
      @user = User.new(user_params)
      @user.wallet = Wallet.new(balance: 0)
      if @user.save
        # Envio mail de bienvenida
        UserMailer.with(user: @user).welcome.deliver_later
        # Si el usuario se guarda correctamente
        redirect_to main_index_path, notice: t(".created")
      else
        # Sino se renderiza de nuevo el formulario new
        # Se pasa como status unprocessable_entity para que TURBO entienda que el formulario no es correcto y se vuelva a renderizar (convención de turbo)
        render :new, status: :unprocessable_entity
      end

    end

    def block
      user
      if (user.toggle(:is_blocked).save)
        user.is_blocked ? UserMailer.with(user: @user).block.deliver_later : UserMailer.with(user: @user).unblock.deliver_later
        redirect_to clients_path, notice: t('.block_toggled')
      else
        redirect_to clients_path, alert: t('.error_block_toggled')
      end
    end
  
    def destroy
      user
      user.update_attribute(:is_deleted, true)
      redirect_to clients_path, notice: t('.destroyed')
    end

    def show
      user
    end

    private

    def user
      @user ||= User.find(params[:id])
    end

    def user_params
      # Se quiere que tenga un objeto User antes que todo el contenido de parámetros
      # Luego se hace el permit con todo lo que debe tener
      params.require(:user).permit(:dni, :name, :surname, :email, :phone, :password, :driver_license, :driver_license_expiration, :birthdate)
    end
end 