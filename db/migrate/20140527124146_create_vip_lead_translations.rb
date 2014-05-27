class CreateVipLeadTranslations < ActiveRecord::Migration
  def change
    create_table :vip_lead_translations do |t|

      t.timestamps
    end
  end
end
