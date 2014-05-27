class PlanTranslations < ActiveRecord::Base
  def up
    Plan.create_translation_table!({
      name: :string,
      user_position: :string,
      lead_management: :string,
      appointment_sheduler: :string,
      social_referrals: :string
    }, {
      migrate_data: true
    })
  end

  def down
    Plan.drop_translation_table! migrate_data: true
  end
end
