class CreateRaceEntries < ActiveRecord::Migration[7.2]
  def change
    create_table :race_entries do |t|
      t.references :race, null: false, foreign_key: true
      t.references :driver, foreign_key: true
      t.references :kart_type, foreign_key: true
      t.integer :kart_number
      t.string :transponder_id
      t.integer :grid_position
      t.integer :finish_position
      t.integer :status
      t.integer :best_lap_ms
      t.integer :total_time_ms
      t.integer :laps_completed

      t.timestamps
    end
  end
end
