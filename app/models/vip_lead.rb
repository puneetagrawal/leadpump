class VipLead < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :phone, :user_id
  belongs_to :user
end
