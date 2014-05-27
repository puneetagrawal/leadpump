class StatsTranslations < ActiveRecord::Base
 def up
    Stats.create_translation_table!({
      source: :string,
      location: :string
    }, {
      migrate_data: true
    })
  end

  def down
    Stats.drop_translation_table! migrate_data: true
  end
end
