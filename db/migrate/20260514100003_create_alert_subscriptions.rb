class CreateAlertSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :alert_subscriptions do |t|
      t.string  :email,      null: false
      t.string  :zip_code,   null: false
      t.string  :token,      null: false
      t.boolean :confirmed,  null: false, default: false

      t.timestamps
    end
    add_index :alert_subscriptions, :email, unique: true
    add_index :alert_subscriptions, :token, unique: true
  end
end
