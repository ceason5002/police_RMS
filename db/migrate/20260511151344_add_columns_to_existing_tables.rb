class AddColumnsToExistingTables < ActiveRecord::Migration[8.1]
  def change
    # Officers — soft-delete / duty status
    add_column :officers, :active, :boolean, default: true, null: false

    # Incidents — link to case, flag for review
    add_column :incidents, :crime_case_id, :integer
    add_column :incidents, :flagged,        :boolean, default: false, null: false
    add_column :incidents, :flagged_reason, :string

    # Users default role
    change_column_default :users, :active, true
  end
end
