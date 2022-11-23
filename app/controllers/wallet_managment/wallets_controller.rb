class WalletManagment::WalletsController < ApplicationController
    
    def show
        @wallet = Wallet.find_by(user_id: params[:id])
    end

    def descontar_saldo
        @wallet = Wallet.find_by(user_id: params[:id])
        @wallet.charge_wallet = wallet_params[:charge_wallet]
        @wallet.balance = @wallet.balance + wallet_params[:charge_wallet].to_i
        @wallet.save
        redirect_to "/wallets/#{params[:user_id]}"
        
    end

    def cargar_saldo
        
        @wallet = Wallet.find_by(user_id: params[:id])
        @wallet.charge_wallet = wallet_params[:charge_wallet]
        @wallet.balance = @wallet.balance + wallet_params[:charge_wallet].to_i
        @wallet.save
        redirect_to "/wallets/#{params[:user_id]}"
    end

    def wallet_params
        params.require(:wallet).permit(:user_id, :charge_wallet)
    end

end
    