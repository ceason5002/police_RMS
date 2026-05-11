class CreateEvidences < ActiveRecord::Migration[8.1]
  def change
    create_table :evidences do |t|
      t.references :incident, null: false, foreign_key: true
      t.string :evidence_number
      t.string :description
      t.string :status
      t.string :location_stored
      t.text :chain_of_custody
      t.datetime :collected_at
      t.string :collected_by

      t.timestamps
    end
  end
end
