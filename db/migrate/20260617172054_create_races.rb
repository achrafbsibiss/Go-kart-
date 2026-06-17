class CreateRaces < ActiveRecord::Migration[7.2]
  def change
    create_table :races do |t|
      t.string :name
      t.references :competition, foreign_key: true
      t.references :track, null: false, foreign_key: true
      t.integer :status
      t.integer :race_type
      t.datetime :scheduled_at
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :total_laps

      t.timestamps
    end
  end
end
