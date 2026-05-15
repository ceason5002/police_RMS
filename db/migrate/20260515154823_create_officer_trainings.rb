class CreateOfficerTrainings < ActiveRecord::Migration[8.1]
  def change
    create_table :officer_trainings do |t|
      t.references :officer, null: false, foreign_key: true
      t.string :training_type, null: false
      t.string :title, null: false
      t.date :completed_on
      t.date :expires_on
      t.decimal :hours, precision: 5, scale: 2
      t.string :status, null: false, default: "Scheduled"
      t.string :instructor
      t.text :notes

      t.timestamps
    end
    add_index :officer_trainings, :status
  end
end
