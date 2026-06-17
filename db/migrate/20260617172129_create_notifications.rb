class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.integer :kind
      t.string :title
      t.text :body
      t.jsonb :data
      t.boolean :broadcast
      t.datetime :read_at

      t.timestamps
    end
  end
end
