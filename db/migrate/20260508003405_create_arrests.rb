class CreateArrests < ActiveRecord::Migration[8.1]
  def change
    create_table :arrests do |t|
      t.references :incident, null: false, foreign_key: true
      t.references :person, null: false, foreign_key: true
      t.text :charges
      t.datetime :arrested_at

      t.timestamps
    end
  end
end
