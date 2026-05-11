class CreatePeople < ActiveRecord::Migration[8.1]
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip_code
      t.text :notes

      t.timestamps
    end
  end
end
