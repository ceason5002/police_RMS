class AddSpotlightToOfficers < ActiveRecord::Migration[8.1]
  def change
    add_column :officers, :featured,      :boolean, default: false, null: false
    add_column :officers, :spotlight_bio, :text
  end
end
