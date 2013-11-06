class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :plan_per_user_range_id
      t.string  :stripe_card_token
      t.integer :customer_id
      t.integer :user_id
      t.integer :locations_count
      t.integer :users_count

      t.timestamps
    end
  end
end
