class AddCustomerIdToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :customer_id, :string
    add_column :subscriptions, :charge_id, :string
  end
end
