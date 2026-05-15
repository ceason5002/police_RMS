class CreateFleetVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :fleet_vehicles do |t|
      t.string :unit_number, null: false
      t.string :make, null: false
      t.string :model, null: false
      t.integer :year, null: false
      t.string :vin
      t.string :color
      t.string :status, null: false, default: "Active"
      t.integer :current_mileage, default: 0
      t.text :notes

      t.timestamps
    end
    add_index :fleet_vehicles, :unit_number, unique: true
    add_index :fleet_vehicles, :status
  end
end
