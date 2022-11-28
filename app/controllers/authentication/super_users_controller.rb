class Authentication::SuperUsersController < ApplicationController

  def index
    @super_users = SuperUser.where(is_deleted: false, is_admin: false)
  end

  def new
    # Para la acción view utilizo una variable de instancia vacia
    # Esta variable de instancia vacia se va a rellenar con el formulario correspondiente
    @super_user = SuperUser.new
  end

def create
  # Se filtran los parámetros instanciando de nuevo
  @super_user = SuperUser.new(super_user_params)

  if @super_user.save
    # Si el super usuario se guarda correctamente
    redirect_to main_index_path, notice: t(".created") 
  else
    # Sino se renderiza de nuevo el formulario new
    # Se pasa como status unprocessable_entity para que TURBO entienda que el formulario no es correcto y se vuelva a renderizar (convención de turbo)
    render :new, status: :unprocessable_entity
  end

end

def block
  super_user
  if (super_user.toggle(:is_blocked).save)
    redirect_to super_users_path, notice: t('.block_toggled')
  else
    redirect_to super_users_path, alert: t('.error_block_toggled')
  end
end

def destroy
  super_user
  super_user.update_attribute(:is_deleted, true)
  redirect_to super_users_path, notice: t('.destroyed')
end

def edit
  super_user
end

def update
  super_user
  if super_user.update(super_user_params)
    redirect_to super_users_path, notice: t('.updated')
  else
    render :edit, status: :unprocessable_entity
  end
end

def show
  super_user
end

private

def super_user
  @super_user ||= SuperUser.find(params[:id])
end

def super_user_params
  # Se quiere que tenga un objeto super_user antes que todo el contenido de parámetros
  # Luego se hace el permit con todo lo que debe tener
  params.require(:super_user).permit(:dni, :name, :surname, :email, :phone, :password)
end

end