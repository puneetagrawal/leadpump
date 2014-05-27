class AutoResponderTranslations < ActiveRecord::Base
  def up
    AutoResponder.create_translation_table!({
      message: :string,
      subject: :string
    }, {
      migrate_data: true
    })
  end

  def down
    AutoResponder.drop_translation_table! migrate_data: true
  end
end
