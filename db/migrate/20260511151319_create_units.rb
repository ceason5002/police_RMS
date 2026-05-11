class CreateUnits < ActiveRecord::Migration[8.1]
  def change
    create_table :units do |t|
      t.string :name
      t.string :unit_type
      t.text :description

      t.timestamps
    end
  end
end
