class CreateTemporaryDataTranslations < ActiveRecord::Migration
  def change
    create_table :temporary_data_translations do |t|

      t.timestamps
    end
  end
end
