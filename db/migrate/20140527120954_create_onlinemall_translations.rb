class CreateOnlinemallTranslations < ActiveRecord::Migration
  def change
    create_table :onlinemall_translations do |t|

      t.timestamps
    end
  end
end
