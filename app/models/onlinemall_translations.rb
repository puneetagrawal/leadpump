class OnlinemallTranslations < ActiveRecord::Base
  def up
    Onlinemall.create_translation_table!({
      title: :string,
      description: :string
    }, {
      migrate_data: true
    })
  end

  def down
    Onlinemall.drop_translation_table! migrate_data: true
  end
end
