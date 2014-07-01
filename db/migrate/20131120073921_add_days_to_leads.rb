class AddDaysToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :no_of_days, :integer
  end
end
