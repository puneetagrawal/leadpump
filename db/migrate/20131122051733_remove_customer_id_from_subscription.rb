class RemoveCustomerIdFromSubscription < ActiveRecord::Migration
  def up
    remove_column :subscriptions, :customer_id
  end

  def down
    add_column :subscriptions, :customer_id, :integer
  end
end
