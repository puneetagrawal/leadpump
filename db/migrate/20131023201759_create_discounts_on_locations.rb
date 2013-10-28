class CreateDiscountsOnLocations < ActiveRecord::Migration
  def change
    create_table :discounts_on_locations do |t|
      t.string :locationRanges
      t.integer :discountPercentage

      t.timestamps
    end
  end
end
