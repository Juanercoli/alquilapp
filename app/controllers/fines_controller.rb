class FinesController < ApplicationController
    
    def new
        @fine= Fine.new
        @user_id=params[:id]
    end

    def create

        @fine = Fine.new(fine_params)
        @fine.user_id=params[:user_id]
        @fine.fine_date=Time.now
        
        if @fine.save
          @fine.user.wallet.update_attribute(:balance, fine.user.wallet.balance - fine_params[:fine_price].to_i)
          UserMailer.with(user: @fine.user,amount: @fine.fine_price ,description: @fine.description ).fined.deliver_later
        redirect_to clients_path, notice: t('.created')
        
        else
          # Sino se renderiza de nuevo el formulario new
          # Se pasa como status unprocessable_entity para que TURBO entienda que el formulario no es correcto y se vuelva a renderizar (convención de turbo)
          redirect_to new_fine_path(params[:user_id]), alert: t('.params_cant_be_empty')
          #render :new,status: :unprocessable_entity
        end
        
    end

    def show

    end

    def destroy
        fine
        fine.update_attribute(:is_deleted, true)
        fine.user.wallet.update_attribute(:balance, fine.user.wallet.balance + fine.fine_price)
        redirect_to fines_path(fine.user_id), notice: t('.destroyed')

    end

    def index
        @fines = Fine.where(is_deleted: false).where(user_id: params[:id])
        if Current.user&.role? == "admin" || Current.user&.role? == "supervisor"
          # Se muestran los autos que no están borrados
          @fines.order(fine_date: :desc)
        else 
          # Se muestran los autos que están visibles
          @fines = @fines.where(is_deleted: true)
        end

    end 

    private
    def fine
        @fine ||= Fine.find(params[:id])
    end

    def fine_params
        # Se quiere que tenga un objeto Car antes que todo el contenido de parámetros
        # Luego se hace el permit con todo lo que debe tener
        params.require(:fine).permit(:description,:fine_price)
    end

    
end