class CreateCadUnits < ActiveRecord::Migration[8.1]
  def change
    create_table :cad_units do |t|
      t.string     :unit_number, null: false
      t.string     :unit_type,   null: false
      t.references :assigned_officer, null: true, foreign_key: { to_table: :officers }
      t.string     :status,      null: false, default: "Available"
      t.timestamps
    end

    add_index :cad_units, :unit_number, unique: true
    add_index :cad_units, :status
  end
end
