class CreateChampionshipStandings < ActiveRecord::Migration[7.2]
  def change
    create_table :championship_standings do |t|
      t.references :competition, null: false, foreign_key: true
      t.references :driver, null: false, foreign_key: true
      t.integer :points
      t.integer :position
      t.integer :rounds_completed
      t.integer :wins

      t.timestamps
    end
  end
end
