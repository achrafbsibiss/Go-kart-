class CreateRegistrations < ActiveRecord::Migration[7.2]
  def change
    create_table :registrations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :registerable, polymorphic: true, null: false
      t.references :driver, foreign_key: true
      t.integer :status
      t.string :reference
      t.datetime :registered_at

      t.timestamps
    end
    add_index :registrations, :reference, unique: true
  end
end
