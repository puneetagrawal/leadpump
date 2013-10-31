class AddPhoneToLead < ActiveRecord::Migration
  def change
    add_column :leads, :phone, :integer, :limit => 8
  end
end
