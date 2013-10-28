class AddChargePerUserToDiscountsOnLocation < ActiveRecord::Migration
  def change
    add_column :discounts_on_locations, :chargePerUser, :string
  end
end
