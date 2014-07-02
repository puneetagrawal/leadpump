class CreateTweetReferrals < ActiveRecord::Migration
  def change
    create_table :tweet_referrals do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
