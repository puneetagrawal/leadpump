class Appointment < ActiveRecord::Base
  attr_accessible :app_date_time, :task,:app_date, :app_source, :app_time, :dues, :email, :enrol, :name, :notes, :phone, :user_id, :lead_id

  belongs_to :lead
  belongs_to :user

  default_scope :order => "app_date_time ASC"

  def self.assigndeletedappointmenttocompany(user)
    company = User.find(1)
    if(user.isEmployee)
      company = user.fetchCompany
    end
  	appointments = Appointment.where(:user_id=>user.id)
    if appointments.present?
      appointments.each do|app|
        app.user_id = company.id
        app.save
      end 
    end
  end

  def self.fetchTodayAppointmentOfUser(user)
    case user.user_role.role_type.to_sym  
    when :admin
      app = Appointment.where("created_at >= ? and created_at <?",Date.today, Date.today+1)  
    when :company
      userList = Company.where(:company_admin_id => user.id).pluck(:company_user_id)
      users = userList
      userList << user.id
      app = Appointment.where(:user_id => userList).where("created_at >= ? and created_at <?",Date.today, Date.today+1)
    when :employee
      app = Appointment.where(:user_id => user.id).where("created_at >= ? and created_at <?",Date.today, Date.today+1)
    end
    app = app.present? ? app.size : 0
  end

end
