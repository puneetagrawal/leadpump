class NewsFeedTranslations < ActiveRecord::Base
  def up
    NewsFeed.create_translation_table!({
      action: :string,
      description: :string
    }, {
      migrate_data: true
    })
  end

  def down
    NewsFeed.drop_translation_table! migrate_data: true
  end
end
