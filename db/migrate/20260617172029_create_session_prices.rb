class CreateSessionPrices < ActiveRecord::Migration[7.2]
  def change
    create_table :session_prices do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.references :kart_type, foreign_key: true
      t.integer :duration_minutes
      t.integer :laps
      t.integer :price_cents
      t.string :currency
      t.integer :category
      t.integer :position
      t.boolean :active

      t.timestamps
    end
    add_index :session_prices, :slug, unique: true
  end
end
