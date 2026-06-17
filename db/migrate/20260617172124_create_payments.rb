class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.references :payable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.integer :amount_cents
      t.string :currency
      t.string :provider
      t.string :provider_ref
      t.integer :status
      t.jsonb :raw
      t.datetime :paid_at

      t.timestamps
    end
  end
end
