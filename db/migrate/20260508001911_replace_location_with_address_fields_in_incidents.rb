class ReplaceLocationWithAddressFieldsInIncidents < ActiveRecord::Migration[8.1]
  def change
    remove_column :incidents, :location, :string
    add_column :incidents, :street_address, :string
    add_column :incidents, :city, :string
    add_column :incidents, :state, :string
    add_column :incidents, :zip_code, :string
  end
end
