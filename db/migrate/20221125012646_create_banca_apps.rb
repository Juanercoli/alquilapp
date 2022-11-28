class CreateBancaApps < ActiveRecord::Migration[7.0]
  def change
    create_table :banca_apps do |t|
      t.integer :total_balance
      t.timestamps
      

    end
  end
end