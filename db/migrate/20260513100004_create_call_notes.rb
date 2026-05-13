class CreateCallNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :call_notes do |t|
      t.references :cad_call, null: false, foreign_key: true
      t.references :user,     null: true,  foreign_key: true
      t.text       :body,     null: false
      t.timestamps
    end
  end
end
