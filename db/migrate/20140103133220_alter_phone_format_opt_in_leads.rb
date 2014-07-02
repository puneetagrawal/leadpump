class AlterPhoneFormatOptInLeads < ActiveRecord::Migration
    def change
    	change_column :opt_in_leads, :phone, :integer, :limit => 8
	end
end
