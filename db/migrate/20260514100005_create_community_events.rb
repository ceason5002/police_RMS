class CreateCommunityEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :community_events do |t|
      t.string   :title,      null: false
      t.text     :description
      t.string   :location
      t.string   :event_type, null: false, default: "General"
      t.datetime :starts_at,  null: false
      t.datetime :ends_at
      t.boolean  :published,  null: false, default: false

      t.timestamps
    end
  end
end
