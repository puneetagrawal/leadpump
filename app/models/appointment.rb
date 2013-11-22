class Appointment < ActiveRecord::Base
  attr_accessible :appdateTime, :task,:app_date, :app_source, :app_time, :dues, :email, :enrol, :name, :notes, :phone, :user_id, :lead_id

  belongs_to :lead
  belongs_to :user
end
