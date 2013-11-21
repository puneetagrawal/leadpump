class Referral < ActiveRecord::Base
  attr_accessible :email, :name, :referrer
  belongs_to :user
end
