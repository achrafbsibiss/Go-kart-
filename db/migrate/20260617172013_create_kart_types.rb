class CreateKartTypes < ActiveRecord::Migration[7.2]
  def change
    create_table :kart_types do |t|
      t.string :name
      t.string :slug
      t.integer :category
      t.text :description
      t.integer :top_speed_kmh
      t.decimal :power_hp
      t.string :engine
      t.integer :weight_kg
      t.integer :min_age
      t.integer :min_height_cm
      t.jsonb :specs
      t.integer :position
      t.boolean :active

      t.timestamps
    end
    add_index :kart_types, :slug, unique: true
  end
end
