class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :plan_id
      t.string :stripe_card_token
      t.integer :user_id

      t.timestamps
    end
  end
end
