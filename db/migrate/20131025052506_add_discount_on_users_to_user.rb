class AddDiscountOnUsersToUser < ActiveRecord::Migration
  def change
    add_column :users, :discountOnUsers, :integer
  end
end
