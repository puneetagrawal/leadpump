class Appointment < ActiveRecord::Base
  attr_accessible :app_date_time, :task,:app_date, :app_source, :app_time, :dues, :email, :enrol, :name, :notes, :phone, :user_id, :lead_id

  belongs_to :lead
  belongs_to :user

  default_scope :order => "app_date_time ASC"


  def self.assigndeletedappointmenttocompany(user)
    company = user.fetchCompany
  	appointments = Appointment.where(:user_id=>user.id)
    if appointments.present?
      appointments.each do|app|
        app.user_id = company.id
        app.save
      end 
    end
  end

end
