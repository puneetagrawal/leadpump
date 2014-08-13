class AddSubscribeToLead < ActiveRecord::Migration
  def change
    add_column :leads, :subscribe, :boolean, default: false 
    add_column :leads, :lead_token, :string
  end
end
