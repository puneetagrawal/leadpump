class CreateOptInLeadTranslations < ActiveRecord::Migration
  def change
    create_table :opt_in_lead_translations do |t|

      t.timestamps
    end
  end
end
