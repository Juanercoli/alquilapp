class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.belongs_to :user, index: { unique: true }, foreign_key: true

      t.string :card_number
      t.string :name
      t.string :surname
      t.date :expiration_date
      t.integer :security_code
      t.integer :card_balance

      t.timestamps
    end
  end
end