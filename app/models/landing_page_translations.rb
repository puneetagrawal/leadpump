class LandingPageTranslations < ActiveRecord::Base
 def up
    LandingPage.create_translation_table!({
      land_type: :string,
      temp_name: :string,
      header_text: :string,
      intro_text: :string,
      mission_text: :string,
      ext_link: :string
    }, {
      migrate_data: true
    })
  end

  def down
    LandingPage.drop_translation_table! migrate_data: true
  end
end
