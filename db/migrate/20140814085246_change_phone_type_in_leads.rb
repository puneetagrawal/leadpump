class ChangePhoneTypeInLeads < ActiveRecord::Migration
  def change
    change_column :leads, :phone, :string
    change_column :vip_leads, :phone, :string
    change_column :opt_in_leads, :phone, :string
    change_column :appointments, :phone, :string
    change_column :addresses, :phone, :string
  end
end
