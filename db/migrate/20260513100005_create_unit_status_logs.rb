class CreateUnitStatusLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :unit_status_logs do |t|
      t.references :cad_unit,   null: false, foreign_key: true
      t.string     :status,     null: false
      t.references :changed_by, null: true, foreign_key: { to_table: :users }
      t.datetime   :changed_at, null: false
      t.timestamps
    end

    add_index :unit_status_logs, :changed_at
  end
end
