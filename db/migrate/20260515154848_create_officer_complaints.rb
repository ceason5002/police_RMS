class CreateOfficerComplaints < ActiveRecord::Migration[8.1]
  def change
    create_table :officer_complaints do |t|
      t.string  :complainant_name
      t.string  :complainant_contact
      t.date    :incident_date
      t.string  :complaint_type, null: false
      t.text    :description, null: false
      t.string  :status, null: false, default: "New"
      t.text    :internal_notes
      t.string  :assigned_investigator
      t.datetime :received_at, null: false

      t.timestamps
    end
    add_index :officer_complaints, :status
  end
end
