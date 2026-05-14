class CreateNewsPosts < ActiveRecord::Migration[8.1]
  def change
    create_table :news_posts do |t|
      t.string  :title,        null: false
      t.text    :body,         null: false
      t.string  :author_name
      t.string  :status,       null: false, default: "Draft"
      t.datetime :published_at

      t.timestamps
    end
  end
end
