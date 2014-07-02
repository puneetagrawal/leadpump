class AddSubscribeToLead < ActiveRecord::Migration
  def change
    add_column :leads, :subscribe, :boolean, default: true 
    add_column :leads, :lead_token, :string
  end
end
