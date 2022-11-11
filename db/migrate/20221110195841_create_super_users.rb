class CreateSuperUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :super_users do |t|
      t.string :name, null: false
      t.string :surname, null: false
      t.string :dni, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :password_digest, null: false
      t.boolean :is_admin, null: false, default: false
      t.boolean :is_blocked, null: false, default: false

      t.timestamps
    end
    add_index :super_users, :dni, unique: true
    add_index :super_users, :email, unique: true
    add_index :super_users, :phone, unique: true
  end
end
