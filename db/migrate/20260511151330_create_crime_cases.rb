class CreateCrimeCases < ActiveRecord::Migration[8.1]
  def change
    create_table :crime_cases do |t|
      t.string :case_number
      t.string :title
      t.string :status
      t.text :description
      t.integer :lead_officer_id

      t.timestamps
    end
  end
end
