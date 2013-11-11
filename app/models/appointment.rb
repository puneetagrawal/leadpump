class Appointment < ActiveRecord::Base
  attr_accessible :app_date, :app_source, :app_time, :dues, :email, :enrol, :name, :notes, :phone

  belongs_to :employee
  validates_presence_of :name, :email, :app_source
end
