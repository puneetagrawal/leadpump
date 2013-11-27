class OptInLead < ActiveRecord::Base
  attr_accessible :email, :source, :phone, :name, :referrer_id
  belongs_to :user
end
