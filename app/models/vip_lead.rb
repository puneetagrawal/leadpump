class VipLead < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :phone, :email, :user_id, :active
  belongs_to :user
end
