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
      user.update_attribute(:pending_license_modification, false)
      user.update_attribute(:must_modify_license, false)         
      user.wallet.update_attribute(:balance, @amount)
      user.update_attribute(:is_accepted, true)
      UserMailer.with(user: user, amount: @amount).accept.deliver_later
      redirect_to pre_registered_path, notice: t('.accepted')
    end

    def reject
      # Enviar mail de por qué rechaza el pre-registro
      UserMailer.with(user: user, motive: params[:motive], observations: params[:observations]).reject.deliver_later
      ##user.destroy
      user.rejected_motive = params[:motive]
      user.rejected_message = params[:observations]
      user.update_attribute(:pending_license_modification, false)
      user.update_attribute(:must_modify_license, true)      
      if user.save
        redirect_to pre_registered_path, notice: t('.rejected')
      else
        flash.now[:notice] = t('unexpected_error')
        render :pre_registered, status: :unprocessable_entity
      end

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

    def edit
      user
    end
    
    def update
      user
      if user.authenticate(user_actual_password_param[:actual_password])
        if user.update(user_edit_params)
          clear_rejected_messages
          redirect_to show_client_path(user.id), notice: t('.updated')
        else
          render :edit, status: :unprocessable_entity
        end
      else
        flash.now[:error] = t('.invalid_actual_password_validation')
        flash.now.alert = t('.invalid_actual_password')
        render :edit, status: :unprocessable_entity
      end
    end

    def edit_password
      user
    end

    def update_password
      user
      if user.authenticate(user_actual_password_param[:actual_password])
        if user.update(user_edit_password_params)
          redirect_to show_client_path(user.id), notice: t('.updated')
        else
          render :edit_password, status: :unprocessable_entity
        end
      else
        flash.now[:error] = t('.invalid_actual_password_validation')
        flash.now.alert = t('.invalid_actual_password')
        render :edit_password, status: :unprocessable_entity
      end      
    end

    def edit_license
      user
    end

    def update_license
      user
      if user.authenticate(user_actual_password_param[:actual_password])
        if user.update(user_edit_license_params)
          user.update_attribute(:pending_license_modification, true)
          redirect_to show_client_path(user.id), notice: t('.updated')
        else
          render :edit_license, status: :unprocessable_entity
        end
      else
        flash.now[:error] = t('.invalid_actual_password_validation')
        flash.now.alert = t('.invalid_actual_password')
        render :edit_license, status: :unprocessable_entity
      end      
    end

    def accept_license
      user
      UserMailer.with(user: user).accept_license.deliver_later
      user.update_attribute(:pending_license_modification, false)
      user.update_attribute(:must_modify_license, false)
      clear_rejected_messages
      redirect_to clients_path, notice: t('.accepted')      
    end
    
    def reject_license
      user
      UserMailer.with(user: user).reject_license.deliver_later
      user.update_attribute(:pending_license_modification, false)
      user.update_attribute(:must_modify_license, true)
      clear_rejected_messages
      redirect_to clients_path, alert: t('.rejected')            
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

    def user_edit_params
      params.require(:user).permit(:dni, :name, :surname, :email, :phone, :birthdate)
    end

    def user_edit_password_params
      params.require(:user).permit(:password)
    end

    def user_edit_license_params
      params.require(:user).permit(:driver_license, :driver_license_expiration)
    end

    def user_actual_password_param
      params.require(:user).permit(:actual_password)
    end

    def clear_rejected_messages
      user.update_attribute(:rejected_motive, "")
      user.update_attribute(:rejected_message, "")
    end
end 