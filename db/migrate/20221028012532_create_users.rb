class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :dni, limit: 8, null: false
      t.string :name, null: false
      t.string :surname, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :password_digest, null: false
      t.date :driver_license_expiration, null: false
      t.date :birthdate, null: false

      t.timestamps
    end
    add_index :users, :dni, unique: true
    add_index :users, :email, unique: true
    add_index :users, :phone, unique: true
  end
end
