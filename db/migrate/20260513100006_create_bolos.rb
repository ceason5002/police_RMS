class CreateBolos < ActiveRecord::Migration[8.1]
  def change
    create_table :bolos do |t|
      t.text       :subject_description
      t.text       :vehicle_description
      t.string     :last_known_location
      t.references :issuing_officer, null: true, foreign_key: { to_table: :officers }
      t.references :created_by,      null: true, foreign_key: { to_table: :users }
      t.datetime   :expires_at
      t.string     :status, null: false, default: "Active"
      t.timestamps
    end

    add_index :bolos, :status
  end
end
