class CreateOpeningHours < ActiveRecord::Migration[7.2]
  def change
    create_table :opening_hours do |t|
      t.references :venue, null: false, foreign_key: true
      t.integer :day_of_week
      t.time :opens_at
      t.time :closes_at
      t.boolean :closed

      t.timestamps
    end
  end
end
