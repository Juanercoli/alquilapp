class WalletManagment::WalletsController < ApplicationController
    
    # te muestra la billetera virtual
    def show
        @wallet = Wallet.find_by(user_id: params[:id]) 
    end

    # metodo para cargar saldo y descontar
    def cargar_saldo
        @card = Card.find_by(user_id: params[:id])
        if (@card.card_balance >= wallet_params[:charge_wallet].to_i)
            @wallet = Wallet.find_by(user_id: params[:id])
            @wallet.charge_wallet = wallet_params[:charge_wallet]
            @wallet.balance = @wallet.balance + wallet_params[:charge_wallet].to_i
            @card.card_balance=@card.card_balance - wallet_params[:charge_wallet].to_i
            @card.save
            @wallet.save
            redirect_to wallet_path(params[:id]), notice:"salgo cargado exitosamente"
        else 
            redirect_to wallet_path(params[:id]), alert:"tu tarjeta no tiene saldo suficiente"
        end
    end

    #metodo para recibir por parametro
    def wallet_params
        params.require(:wallet).permit(:user_id, :charge_wallet)
    end

    #def descontar_saldo
    #    @wallet = Wallet.find_by(user_id: params[:id])
    #    @wallet.charge_wallet = wallet_params[:charge_wallet]
    #   @wallet.balance = @wallet.balance + wallet_params[:charge_wallet].to_i
    #    @wallet.save
    #    redirect_to "/wallets/#{params[:user_id]}"   
    #end

    # crea una wallet nueva
    def new
        @wallet = Wallet.new
    end
    
    # creacion de wallet
    def create
        @wallet = Wallet.create(wallet_params)
        if @wallet.save
          redirect_to wallet_path, success: 'Billetera creada con éxito'
        else
          render :new, status: :unprocessable_entity
        end
    end





end
    