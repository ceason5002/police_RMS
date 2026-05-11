class CreateOfficers < ActiveRecord::Migration[8.1]
  def change
    create_table :officers do |t|
      t.string :badge_number
      t.string :first_name
      t.string :last_name
      t.string :rank
      t.text :assignments

      t.timestamps
    end
  end
end
