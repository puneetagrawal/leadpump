class CreateRoleTranslations < ActiveRecord::Migration
  def change
    create_table :role_translations do |t|

      t.timestamps
    end
  end
end
