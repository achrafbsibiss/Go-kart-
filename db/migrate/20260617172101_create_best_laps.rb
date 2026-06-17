class CreateBestLaps < ActiveRecord::Migration[7.2]
  def change
    create_table :best_laps do |t|
      t.references :driver, null: false, foreign_key: true
      t.references :track, null: false, foreign_key: true
      t.references :kart_type, foreign_key: true
      t.references :race, foreign_key: true
      t.integer :lap_time_ms
      t.datetime :recorded_at

      t.timestamps
    end
  end
end
