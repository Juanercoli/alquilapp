class CreateCarUsageHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :car_usage_histories do |t|
      t.datetime :start
      t.datetime :end
      t.belongs_to :car, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end
