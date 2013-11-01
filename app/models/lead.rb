class Lead < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :address, :phone, :email, :address, :refferred_by, :lead_source, :guest_pass_issued, :dues_value, :enrolment_value, :notes, :user_id
  belongs_to :user

  validates :email, :presence => true, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  validates :first_name, :presence => true
  validates :phone, :numericality => {:only_integer => true}
end
