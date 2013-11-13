class AddEmailToVipLead < ActiveRecord::Migration
  def change
    add_column :vip_leads, :email, :string
    add_column :vip_leads, :active, :boolean, :default => false
  end
end
