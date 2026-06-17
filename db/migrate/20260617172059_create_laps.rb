class CreateLaps < ActiveRecord::Migration[7.2]
  def change
    create_table :laps do |t|
      t.references :race_entry, null: false, foreign_key: true
      t.integer :lap_number
      t.integer :lap_time_ms
      t.jsonb :sector_times
      t.datetime :recorded_at

      t.timestamps
    end
  end
end
