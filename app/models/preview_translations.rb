class PreviewTranslations < ActiveRecord::Base
  def up
    Preview.create_translation_table!({
      header_text: :string,
      temp_name: :string,
      intro_text: :string,
      mission_text: :string
    }, {
      migrate_data: true
    })
  end

  def down
    Preview.drop_translation_table! migrate_data: true
  end
end
