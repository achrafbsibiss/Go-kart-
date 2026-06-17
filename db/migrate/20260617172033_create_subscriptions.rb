class CreateSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :membership_plan, null: false, foreign_key: true
      t.integer :status
      t.datetime :started_at
      t.datetime :ends_at
      t.boolean :auto_renew

      t.timestamps
    end
  end
end
