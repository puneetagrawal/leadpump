class FrontDeskDescTranslations < ActiveRecord::Base
  def up
    FrontDeskDesc.create_translation_table!({
      description: :string,
      title: :string
    }, {
      migrate_data: true
    })
  end

  def down
    FrontDeskDesc.drop_translation_table! migrate_data: true
  end
end
