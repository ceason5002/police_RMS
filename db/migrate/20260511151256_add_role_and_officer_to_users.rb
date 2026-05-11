class AddRoleAndOfficerToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :role, :string
    add_column :users, :officer_id, :integer
    add_column :users, :active, :boolean
  end
end
