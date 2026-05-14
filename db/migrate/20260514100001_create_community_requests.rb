class CreateCommunityRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :community_requests do |t|
      t.string  :request_type,  null: false
      t.text    :description,   null: false
      t.string  :location,      null: false
      t.string  :contact_name
      t.string  :contact_email
      t.string  :contact_phone
      t.string  :status,        null: false, default: "New"
      t.text    :internal_notes
      t.references :incident, foreign_key: true

      t.timestamps
    end
  end
end
