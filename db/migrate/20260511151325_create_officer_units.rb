class CreateOfficerUnits < ActiveRecord::Migration[8.1]
  def change
    create_table :officer_units do |t|
      t.references :officer, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
