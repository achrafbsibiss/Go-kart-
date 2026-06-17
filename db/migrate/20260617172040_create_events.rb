class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.integer :kind
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :location
      t.boolean :featured

      t.timestamps
    end
    add_index :events, :slug, unique: true
  end
end
