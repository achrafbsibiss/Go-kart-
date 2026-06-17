class CreateTournamentMatches < ActiveRecord::Migration[7.2]
  def change
    create_table :tournament_matches do |t|
      t.references :competition, null: false, foreign_key: true
      t.integer :round
      t.integer :slot
      t.references :driver_a, foreign_key: { to_table: :drivers }
      t.references :driver_b, foreign_key: { to_table: :drivers }
      t.references :winner, foreign_key: { to_table: :drivers }
      t.string :score
      t.datetime :scheduled_at

      t.timestamps
    end
  end
end
