class CreateAuditLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :audit_logs do |t|
      t.integer :user_id
      t.string :action
      t.string :resource_type
      t.integer :resource_id
      t.text :details
      t.string :ip_address

      t.timestamps
    end
  end
end
