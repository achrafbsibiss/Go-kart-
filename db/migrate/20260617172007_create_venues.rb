class CreateVenues < ActiveRecord::Migration[7.2]
  def change
    create_table :venues do |t|
      t.string :name
      t.text :description
      t.string :address
      t.string :city
      t.string :country
      t.string :postal_code
      t.string :phone
      t.string :email
      t.decimal :latitude
      t.decimal :longitude
      t.jsonb :socials

      t.timestamps
    end
  end
end
