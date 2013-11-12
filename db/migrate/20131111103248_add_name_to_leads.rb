class AddNameToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :lname, :string
  end
end
