class CreateFines < ActiveRecord::Migration[7.0]
  def change
    create_table :fines do |t|
      t.text :description
      t.integer :fine_price
      t.datetime :fine_date
      t.belongs_to :user, foreign_key: true
      t.boolean :is_deleted, null: false, default: false
      t.timestamps
    end
  end
end
