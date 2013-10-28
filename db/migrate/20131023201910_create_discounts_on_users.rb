class CreateDiscountsOnUsers < ActiveRecord::Migration
  def change
    create_table :discounts_on_users do |t|
      t.string :userRanges
      t.integer :discountPercentage

      t.timestamps
    end
  end
end
