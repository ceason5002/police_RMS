class CreateIncidents < ActiveRecord::Migration[8.1]
  def change
    create_table :incidents do |t|
      t.string :report_number
      t.string :incident_type
      t.string :status
      t.string :location
      t.datetime :occurred_at
      t.datetime :reported_at
      t.text :narrative

      t.timestamps
    end
  end
end
