class CreateFleetLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :fleet_logs do |t|
      t.references :fleet_vehicle, null: false, foreign_key: true
      t.string :log_type, null: false
      t.string :description, null: false
      t.datetime :logged_at, null: false
      t.integer :mileage
      t.decimal :cost, precision: 8, scale: 2
      t.string :performed_by
      t.text :notes

      t.timestamps
    end
  end
end
