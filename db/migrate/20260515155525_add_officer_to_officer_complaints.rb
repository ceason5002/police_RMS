class AddOfficerToOfficerComplaints < ActiveRecord::Migration[8.1]
  def change
    add_reference :officer_complaints, :officer, null: true, foreign_key: true
  end
end
