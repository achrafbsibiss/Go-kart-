class CreateCompetitions < ActiveRecord::Migration[7.2]
  def change
    create_table :competitions do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.integer :format
      t.integer :status
      t.datetime :starts_at
      t.datetime :ends_at
      t.datetime :registration_opens_at
      t.datetime :registration_closes_at
      t.integer :capacity
      t.integer :entry_fee_cents
      t.string :currency
      t.references :track, foreign_key: true

      t.timestamps
    end
    add_index :competitions, :slug, unique: true
  end
end
