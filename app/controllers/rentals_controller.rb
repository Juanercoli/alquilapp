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
        @wallet.balance=@wallet.balance - @rental.initial_hours_quantity * 200
        @wallet.save!
        @rental.car_id = params[:car_id]
        @rental.user_id = Current.user.id
        @rental.extra_hours_quantity = 0
        @rental.multed_hours_quantity = 0
        @rental.is_active=true
        @rental.save!  
        pp @rental     
        redirect_to find_car_path(@rental.id), notice: t('.rented')
      else
        # Posible error , creo q ya esta arreglado
        redirect_to new_rental_path(params[:car_id]), alert: t('.not_enough_balance')
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
        @rental.car.update_attribute(:is_rented, true) 
        redirect_to car_tracking_path(@rental.id), notice: t('.unlocked')
      else
        redirect_to find_car_path(@rental.id), alert: t('.invalid_patent')
      end

  end

  # Agregar mas tiempo
  def edit
    rental
  end

  def update
    rental
    @wallet=Current.user.wallet
    aux=rental_params[:extra_hours_quantity].to_i
    sumatoria=@rental.extra_hours_quantity + aux
    
    if (sumatoria+@rental.initial_hours_quantity <= 24 )
      if (Current.user.wallet.balance >= aux*250)
         @rental.extra_hours_quantity=sumatoria
         redirect_to car_tracking_path(@rental.id), notice: t('.added_time')
         @wallet.balance= @wallet.balance - aux* 250
         @rental.save!
         @wallet.save!
     else
        redirect_to edit_rental_path(@rental.id), alert: t('.not_enough_balance')
      end
    else 
      redirect_to edit_rental_path(@rental.id), alert: t('.exceds_rental_time')
    end
  end



  def car_tracking
      rental
  end

  # Saca la cuenta final y muestra el resumen
  def show
    rental
    @wallet=Current.user.wallet
    @rental.price = @rental.initial_hours_quantity * 200 + @rental.extra_hours_quantity*250 + @rental.multed_hours_quantity*100*4
    @rental.is_active=false
    rental.save!
    @wallet.balance=@wallet.balance - @rental.multed_hours_quantity*100*4
    @wallet.save!
    CarUsageHistory.create!(start:rental.created_at, end:rental.updated_at, car_id: @rental.car.id, user_id: Current.user.id)
    @rental.car.update_attribute(:is_rented, false)
  end

  def index
    @rentals=Rental.order(created_at: :desc).where(user_id: Current.user.id)
  end
  

  private
  def rental_params
    
    params.require(:rental).permit(:initial_hours_quantity,:car_id,:car_patent,:extra_hours_quantity,:multed_hours_quantity)
  end

  def rental
    @rental ||= Rental.find(params[:id])
  end
end