class WalletManagment::CardsController < ApplicationController

    def show
        @card = Card.find_by(id: params[:id]) 
    end

    def new
        @card = Card.new
    end
      
    def create
        # Se filtran los parámetros instanciando de nuevo
        
        @card = Card.new(card_params)
        @card.card_balance = 1000
        @card.user_id=Current.user.id
        if @card.save
          redirect_to wallet_path(Current.user.id), notice:"tarjeta agregada"
        else
          # Sino se renderiza de nuevo el formulario new
          # Se pasa como status unprocessable_entity para que TURBO entienda que el formulario no es correcto y se vuelva a renderizar (convención de turbo)
          render :new, status: :unprocessable_entity
         end
    end

    private

    def card_params
      # Se quiere que tenga un objeto User antes que todo el contenido de parámetros
      # Luego se hace el permit con todo lo que debe tener
      params.require(:card).permit(:card_number, :name, :surname, :expiration_date,:security_code)
    end
end