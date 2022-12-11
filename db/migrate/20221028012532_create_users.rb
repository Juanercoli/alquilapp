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
      t.boolean :is_blocked, default: false, null: false
      t.boolean :is_accepted, default: false, null: false
      t.boolean :is_deleted, default: false, null: false
      t.string :rejected_motive, default: "", null: false
      t.string :rejected_message, default: "", null: false
      t.boolean :pending_license_modification, default: false, null: false
      t.boolean :must_modify_license, default: false, null: false

      t.timestamps
    end
    add_index :users, :dni, unique: true
    add_index :users, :email, unique: true
    add_index :users, :phone, unique: true
  end
end
