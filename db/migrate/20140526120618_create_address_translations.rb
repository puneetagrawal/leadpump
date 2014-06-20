class CreateAddressTranslations < ActiveRecord::Migration
  def up
    Address.create_translation_table!({
      address: :string,
      city: :string,
      state: :string
    }, {
      migrate_data: true
    })
  end

  def down
    Address.drop_translation_table! migrate_data: true
  end
end
