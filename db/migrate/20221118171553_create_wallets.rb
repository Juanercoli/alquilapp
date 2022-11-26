class CreateWallets < ActiveRecord::Migration[7.0]
  
  
  def change
    create_table :wallets do |t|
      
      t.belongs_to :user, index: { unique: true }, foreign_key: true
      # balance es el saldo actual del usuario
      t.integer :balance
      # es el gasto total del ultimo viaje
      t.integer :resume
      # variable q se usa para cargar la wallet
      t.integer :charge_wallet
      # talves no se usan
      t.integer :dni
      t.boolean :verification
      t.timestamps
    end
  end

end
