class CreateDiscountsOnPeriods < ActiveRecord::Migration
  def change
    create_table :discounts_on_periods do |t|
      t.string :periodType
      t.integer :discountPercentage

      t.timestamps
    end
  end
end
