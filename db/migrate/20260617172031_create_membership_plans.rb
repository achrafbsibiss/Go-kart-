class CreateMembershipPlans < ActiveRecord::Migration[7.2]
  def change
    create_table :membership_plans do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.integer :price_cents
      t.string :currency
      t.integer :period
      t.jsonb :benefits
      t.boolean :popular
      t.integer :position
      t.boolean :active

      t.timestamps
    end
    add_index :membership_plans, :slug, unique: true
  end
end
