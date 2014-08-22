class UserLeads < ActiveRecord::Base
  attr_accessible :user_id, :lead_id
  belongs_to :user
  belongs_to :lead
  has_many :auto_responder_records

	# scope :by_emp_name, lambda { |emp_name| where('') unless status == "All Statuses" || status.blank? }
	# scope :by_lead_name, lambda { |name| where('title ilike ?', name+"%") unless name.blank? }
  # scope :by_lead_name, lambda { |emp_name| includes(:lead).where("lead.name like ?", "#{emp_name}%") unless emp_name.blank?}
end
