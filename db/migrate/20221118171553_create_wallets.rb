class CreateWallets < ActiveRecord::Migration[7.0]
  
  
  def change
    create_table :wallets do |t|
      
      t.belongs_to :user, index: { unique: true }, foreign_key: true
      t.integer :balance
      t.integer :resume
      t.integer :charge_wallet
      # talves no se usan
      t.integer :dni
      t.boolean :verification
      t.timestamps
    end
  end

end
