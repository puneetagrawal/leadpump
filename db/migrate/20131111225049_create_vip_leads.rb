class CreateVipLeads < ActiveRecord::Migration
  def change
    create_table :vip_leads do |t|
      t.string :first_name
      t.string :last_name
      t.integer :phone,:limit => 8
      t.integer :user_id

      t.timestamps
    end
  end
end
