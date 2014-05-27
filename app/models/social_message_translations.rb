class SocialMessageTranslations < ActiveRecord::Base
 def up
    SocialMessage.create_translation_table!({
      facebookMessage: :text,
      gmailMessage: :text,
      twitterMessage: :text,
      gmailsubject: :string,
      fbsubject: :text
    }, {
      migrate_data: true
    })
  end

  def down
    SocialMessage.drop_translation_table! migrate_data: true
  end
end
