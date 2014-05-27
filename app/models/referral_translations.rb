class ReferralTranslations < ActiveRecord::Base
  def up
    Referral.create_translation_table!({
      name: :string
    }, {
      migrate_data: true
    })
  end

  def down
    Referral.drop_translation_table! migrate_data: true
  end
end
