class CreatePlanPerUserRanges < ActiveRecord::Migration
  def change
    create_table :plan_per_user_ranges do |t|
      t.integer :plan_id
      t.integer :user_range_id
      t.integer :price

      t.timestamps
    end
  end
end
