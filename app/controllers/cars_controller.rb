class CarsController < ApplicationController
  def index
    @cars = Car.where(is_deleted: false)
  end
  def new
    # Para la acción view utilizo una variable de instancia vacia
    # Esta variable de instancia vacia se va a rellenar con el formulario correspondiente
    @car = Car.new
  end
  
  def create
    # Se filtran los parámetros instanciando de nuevo
    @car = Car.new(car_params)

    if @car.save
    # Si el auto se guarda correctamente
    # Y se redirige a la página principal
    #!! REDIRECCION A PAGINA PRINCIPAL
    redirect_to new_car_path, notice: "t('.created')"
    else
    # Sino se renderiza de nuevo el formulario new
    # Se pasa como status unprocessable_entity para que TURBO entienda que el formulario no es correcto y se vuelva a renderizar (convención de turbo)
      render :new, status: :unprocessable_entity
    end
  end
  def edit
    car
  end
  def update
    car
    if car.update(car_params)
      redirect_to cars_path, notice: "updated"
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def show
    car
  end
  def logic_delete
    car
    car.update_attribute(:is_deleted,true)
    redirect_to cars_path
  end
  def destroy
  end

  private
  def car
    @car ||= Car.find(params[:id])
  end
  def car_params
    # Se quiere que tenga un objeto Car antes que todo el contenido de parámetros
    # Luego se hace el permit con todo lo que debe tener
    params.require(:car).permit(:patent, :model, :vehicle_number, :color, :brand)
  end
end 

