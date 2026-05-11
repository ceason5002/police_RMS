class CreateVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicles do |t|
      t.string :plate_number
      t.string :make
      t.string :model
      t.integer :year
      t.string :color
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
