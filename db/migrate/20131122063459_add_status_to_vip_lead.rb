class AddStatusToVipLead < ActiveRecord::Migration
  def change
    add_column :vip_leads, :status, :string
  end
end
