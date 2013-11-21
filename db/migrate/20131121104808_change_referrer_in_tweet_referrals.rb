class ChangeReferrerInTweetReferrals < ActiveRecord::Migration
  def up
  	change_column :tweet_referrals, :referrer, :integer
  end

  def down
  	change_column :tweet_referrals, :referrer, :string
  end
end
