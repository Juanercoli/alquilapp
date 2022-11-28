class CreateCars < ActiveRecord::Migration[7.0]
  def change
    create_table :cars do |t|
      t.string :brand, null: false
      t.string :patent, null: false
      t.string :model, null: false
      t.integer :vehicle_number, null: false
      t.string :color, null: false
      t.boolean :is_deleted, null: false, default: false
      t.boolean :is_visible, null: false, default: true
      
      t.timestamps
    end
    add_index :cars, :patent, unique: true
    add_index :cars, :vehicle_number, unique: true
  end
end
