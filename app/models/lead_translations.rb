class LeadTranslations < ActiveRecord::Base
  def up
    Lead.create_translation_table!({
      name: :string,
      lname: :string,
      address: :string,
      goal: :string,
      lead_source: :string,
      notes: :string,
      status: :string,
      city: :string,
      gender: :string,
      state: :string,
      currently_exercise: :string,
      program_span: :string
    }, {
      migrate_data: true
    })
  end

  def down
    Lead.drop_translation_table! migrate_data: true
  end
end
