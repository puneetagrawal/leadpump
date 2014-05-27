class OptInLeadTranslations < ActiveRecord::Base
  def up
    OptInLead.create_translation_table!({
      source: :string,
      name: :string
    }, {
      migrate_data: true
    })
  end

  def down
    OptInLead.drop_translation_table! migrate_data: true
  end
end
