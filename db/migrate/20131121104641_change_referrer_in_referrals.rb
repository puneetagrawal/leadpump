class ChangeReferrerInReferrals < ActiveRecord::Migration
  def up
  	#change_column :referrals, :referrer, :integer
  end

  def down
  	#change_column :referrals, :referrer, :string
  end
end
