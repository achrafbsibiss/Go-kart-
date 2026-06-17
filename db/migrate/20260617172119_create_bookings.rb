class CreateBookings < ActiveRecord::Migration[7.2]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :session_price, null: false, foreign_key: true
      t.references :kart_type, foreign_key: true
      t.datetime :starts_at
      t.integer :party_size
      t.integer :status
      t.integer :total_cents
      t.string :currency
      t.text :notes
      t.string :reference

      t.timestamps
    end
    add_index :bookings, :reference, unique: true
  end
end
