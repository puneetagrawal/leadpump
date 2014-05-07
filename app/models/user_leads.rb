class UserLeads < ActiveRecord::Base
  attr_accessible :user_id, :lead_id
  belongs_to :user
  belongs_to :lead
  has_many :auto_responder_records
  
end
