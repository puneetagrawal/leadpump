class CreateNewsFeeds < ActiveRecord::Migration
  def change
    create_table :news_feeds do |t|
      t.string :description
      t.string :action
      t.date :feed_date
      t.belongs_to :user
      t.belongs_to :lead
      t.timestamps
    end
  end
end
