class CreateRentals < ActiveRecord::Migration[7.0]
  def change
    create_table :rentals do |t|
      t.integer :initial_hours_quantity
      t.integer :extra_hours_quantity
      t.integer :multed_hours_quantity
      t.integer :price
      t.boolean :is_active , default:false
      t.belongs_to :car, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end
