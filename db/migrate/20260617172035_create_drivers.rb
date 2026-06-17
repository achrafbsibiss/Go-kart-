class CreateDrivers < ActiveRecord::Migration[7.2]
  def change
    create_table :drivers do |t|
      t.references :user, foreign_key: true
      t.string :nickname
      t.string :slug
      t.string :transponder_id
      t.text :bio
      t.string :country
      t.integer :total_races
      t.integer :best_lap_ms
      t.integer :points

      t.timestamps
    end
    add_index :drivers, :slug, unique: true
  end
end
