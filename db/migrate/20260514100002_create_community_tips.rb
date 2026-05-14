class CreateCommunityTips < ActiveRecord::Migration[8.1]
  def change
    create_table :community_tips do |t|
      t.string :tip_type,    null: false
      t.text   :description, null: false
      t.string :location
      t.string :status,      null: false, default: "New"
      t.text   :internal_notes

      t.timestamps
    end
  end
end
