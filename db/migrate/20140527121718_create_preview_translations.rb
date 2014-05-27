class CreatePreviewTranslations < ActiveRecord::Migration
  def change
    create_table :preview_translations do |t|

      t.timestamps
    end
  end
end
