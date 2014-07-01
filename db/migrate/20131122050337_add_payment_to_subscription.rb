class AddPaymentToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :payment, :integer
  end
end
