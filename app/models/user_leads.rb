class UserLeads < ActiveRecord::Base
  attr_accessible :user_id, :lead_id
  belongs_to :user
  belongs_to :lead

  
end
