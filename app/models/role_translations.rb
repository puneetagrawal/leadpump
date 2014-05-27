class RoleTranslations < ActiveRecord::Base
  def up
    Role.create_translation_table!({
      role_type: :string
    }, {
      migrate_data: true
    })
  end

  def down
    Role.drop_translation_table! migrate_data: true
  end
end
