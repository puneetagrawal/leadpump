class CreateNewsFeedTranslations < ActiveRecord::Migration
  def change
    create_table :news_feed_translations do |t|

      t.timestamps
    end
  end
end
