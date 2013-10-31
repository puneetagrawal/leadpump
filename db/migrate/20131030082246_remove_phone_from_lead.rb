class RemovePhoneFromLead < ActiveRecord::Migration
  def up
    remove_column :leads, :phone
  end

  def down
    add_column :leads, :phone, :integer
  end
end
