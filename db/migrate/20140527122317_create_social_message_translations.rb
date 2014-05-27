class CreateSocialMessageTranslations < ActiveRecord::Migration
  def change
    create_table :social_message_translations do |t|

      t.timestamps
    end
  end
end
