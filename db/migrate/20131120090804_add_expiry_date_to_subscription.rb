class AddExpiryDateToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :expiry_date, :date
  end
end
