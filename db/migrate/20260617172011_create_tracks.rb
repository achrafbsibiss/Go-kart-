class CreateTracks < ActiveRecord::Migration[7.2]
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.integer :length_m
      t.integer :corners
      t.string :surface

      t.timestamps
    end
    add_index :tracks, :slug, unique: true
  end
end
