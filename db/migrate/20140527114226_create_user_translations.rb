class CreateUserTranslations < ActiveRecord::Migration
  def up
    User.create_translation_table!({
      name: :string,
      lname: :string,
      company_name: :string
    }, {
      migrate_data: true
    })
  end

  def down
    User.drop_translation_table! migrate_data: true
  end
end

