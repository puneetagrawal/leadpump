class AddPlanTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :planType, :integer
  end
end
