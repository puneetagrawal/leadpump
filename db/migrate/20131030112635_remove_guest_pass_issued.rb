class RemoveGuestPassIssued < ActiveRecord::Migration
  def self.up
    remove_column :leads, :guest_pass_issued  	
  end

  def down
  end
end
