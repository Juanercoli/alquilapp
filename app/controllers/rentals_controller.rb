class RentalsController < ApplicationController
  def new
    @rental = Rental.new()
    @car_id = params[:car_id]
  end
  def create
    if Current.user 
      
      @rental = Rental.new(rental_params)
      @wallet = Wallet.find_by(user_id:Current.user.id)
      price = @rental.initial_hours_quantity * 200
      if (price <= @wallet.balance)
        @wallet.balance = @wallet.balance - price
        @wallet.save!
        pp @rental
        @rental.car_id = params[:car_id]
        @rental.user_id = Current.user.id
        pp @rental
        @rental.save!
        pp @rental
        redirect_to wallet_path(@wallet.id), notice: t(".caso_exitoso")
      else
        redirect_to new_rental_path, alert: t('.no_alcanza')
      end
    end
  end
  private
  def rental_params
    # Se quiere que tenga un objeto User antes que todo el contenido de parámetros
    # Luego se hace el permit con todo lo que debe tener
    params.require(:rental).permit(:initial_hours_quantity)
  end
end