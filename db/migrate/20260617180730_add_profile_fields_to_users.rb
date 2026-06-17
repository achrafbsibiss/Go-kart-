class AddProfileFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :role, :integer, null: false, default: 0 unless column_exists?(:users, :role)
    add_column :users, :first_name, :string unless column_exists?(:users, :first_name)
    add_column :users, :last_name, :string unless column_exists?(:users, :last_name)
    add_column :users, :phone, :string unless column_exists?(:users, :phone)
    add_column :users, :locale, :string, null: false, default: "fr" unless column_exists?(:users, :locale)
    add_column :users, :marketing_opt_in, :boolean, null: false, default: false unless column_exists?(:users, :marketing_opt_in)
  end
end
