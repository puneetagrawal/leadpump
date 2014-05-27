class CreateLeadTranslations < ActiveRecord::Migration
  def change
    create_table :lead_translations do |t|

      t.timestamps
    end
  end
end
