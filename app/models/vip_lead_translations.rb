class VipLeadTranslations < ActiveRecord::Base
  def up
    VipLead.create_translation_table!({
      first_name: :string,
      last_name: :string,
      status: :string
    }, {
      migrate_data: true
    })
  end

  def down
    VipLead.drop_translation_table! migrate_data: true
  end
end
