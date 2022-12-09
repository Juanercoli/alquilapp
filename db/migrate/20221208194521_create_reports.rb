class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.time :date
      t.text :content
      t.string :report_type
      t.boolean :state
      t.belongs_to :car, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end
