class CreateCadCalls < ActiveRecord::Migration[8.1]
  def change
    create_table :cad_calls do |t|
      t.string   :call_number,   null: false
      t.string   :caller_name
      t.string   :caller_phone
      t.string   :location,      null: false
      t.decimal  :latitude,      precision: 10, scale: 7
      t.decimal  :longitude,     precision: 10, scale: 7
      t.string   :call_type,     null: false
      t.integer  :priority,      null: false, default: 3
      t.text     :description
      t.string   :status,        null: false, default: "Pending"
      t.datetime :received_at,   null: false
      t.datetime :dispatched_at
      t.datetime :on_scene_at
      t.datetime :cleared_at
      t.references :incident,    null: true, foreign_key: true
      t.references :created_by,  null: true, foreign_key: { to_table: :users }
      t.timestamps
    end

    add_index :cad_calls, :call_number, unique: true
    add_index :cad_calls, :status
    add_index :cad_calls, :priority
  end
end
