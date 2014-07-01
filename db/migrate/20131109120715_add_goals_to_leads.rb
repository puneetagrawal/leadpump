class AddGoalsToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :goal, :string
  end
end
