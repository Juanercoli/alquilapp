class RentalsController < ApplicationController
  def new
    @rental = Rental.new()
    @car_id = params[:id]
    
  end
  def create
    if Current.user 
      @rental = Rental.new(rental_params)
      @wallet = Wallet.find_by(user_id:Current.user.id)
      @rental.price = @rental.initial_hours_quantity * 200
      
      if (@rental.price <= @wallet.balance)
        @wallet.save!
        @rental.car_id = params[:car_id]
        @rental.user_id = Current.user.id
        @rental.extra_hours_quantity = 0
        @rental.multed_hours_quantity = 0
        @rental.is_active=true
        @rental.save!   
        pp @rental     
        redirect_to find_car_path(@rental.id), notice: t('El auto ha sido alquilado exitosamente')
      else
        redirect_to new_rental_path, alert: t('Usted no posee el saldo suficiente , recargue su saldo')
      end
    end
  end

  def find_car 
      rental
  end


  def car_unlock
      rental
      pp rental.car.patent
      if rental.car.patent == params[:patent]
        redirect_to car_tracking_path(@rental.id), notice: t('Se ha desbloqueado exitosamente el vehículo')
      else
        redirect_to find_car_path(@rental.id), alert: t('La patente ingresada es invalida. Ingrésela nuevamente')
      end

  end

  #agregar mas tiempo
  def edit
    rental
  end

  def update
    rental
    aux=rental_params[:extra_hours_quantity].to_i
    aux=@rental.extra_hours_quantity + aux
    aux2=@rental.initial_hours_quantity
    if (aux+aux2 <= 24 )
      if (Current.user.wallet.balance >= aux*250+aux2*200)
         @rental.extra_hours_quantity=aux
         redirect_to car_tracking_path(@rental.id), notice: t("Tiempo agregado")
         @rental.save!
     else
        redirect_to edit_rental_path(@rental.id), alert: t("saldo insuficiente")
      end
    else 
      redirect_to edit_rental_path(@rental.id), alert: t('Se ha excedido el tiempo máximo de alquiler')
    end
  end



  def car_tracking
      rental
  end

  #saca la cuenta final y muestra el resumen
  def show
    rental
    @wallet=Current.user.wallet
    @rental.price = @rental.initial_hours_quantity * 200 + @rental.extra_hours_quantity*250 + @rental.multed_hours_quantity*100*4
    @rental.is_active=false
    rental.save!
    @wallet.balance=@wallet.balance - @rental.price
    @wallet.save!
    CarUsageHistory.create!(start:rental.created_at, end:rental.updated_at, car_id: @rental.car.id, user_id: Current.user.id)
  end


  

  private
  def rental_params
    
    params.require(:rental).permit(:initial_hours_quantity,:car_id,:car_patent,:extra_hours_quantity,:multed_hours_quantity)
  end

  def rental
    @rental ||= Rental.find(params[:id])
  end
end