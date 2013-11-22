class AddPlanTypeToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :plan_type, :string
  end
end
