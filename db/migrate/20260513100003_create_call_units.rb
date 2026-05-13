class CreateCallUnits < ActiveRecord::Migration[8.1]
  def change
    create_table :call_units do |t|
      t.references :cad_call,    null: false, foreign_key: true
      t.references :cad_unit,    null: false, foreign_key: true
      t.datetime   :assigned_at, null: false
      t.timestamps
    end

    add_index :call_units, [:cad_call_id, :cad_unit_id], unique: true
  end
end
