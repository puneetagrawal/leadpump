class Appointment < ActiveRecord::Base
  attr_accessible :app_date, :app_source, :app_time, :dues, :email, :enrol, :name, :notes, :phone

  belongs_to :employee
  validates_presence_of :name, :app_source, :dues, :app_time
  validates :phone, :numericality => {:only_integer => true}
  validates :email, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
end
