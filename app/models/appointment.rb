class Appointment < ActiveRecord::Base
  attr_accessible :app_date_time, :task,:app_date, :app_source, :app_time, :dues, :email, :enrol, :name, :notes, :phone, :user_id, :lead_id

  translates :task
  
  belongs_to :lead
  belongs_to :user

  default_scope :order => "app_date_time ASC"

  def self.assigndeletedappointmenttocompany(user)
    if user.isEmployee
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

  def self.fetchuserappointments(user,date)
      case user.user_role.role_type.to_sym  
      when :admin
        appointments = Appointment.includes(:lead).includes(:user).where("app_date_time >= ? and app_date_time < ?", date,date + 1)  
      when :company
        users = Company.where(:company_admin_id => user.id).pluck(:company_user_id)
        users << user.id
        users = users.present? ? users.uniq : []
        appointments = Appointment.includes(:lead).includes(:user).where(:user_id=>users).where("app_date = ?", date)
      when :employee
        appointments = Appointment.includes(:lead).includes(:user).where(:user_id=>user.id).where("app_date = ?", date)
    end
    return appointments
  end

  def self.fetchuserappointmentFilter(user,date)
      case user.user_role.role_type.to_sym  
      when :admin
        appointments = Appointment.includes(:lead).includes(:user).where("app_date = ?", date)  
      when :company
        users = Company.where(:company_admin_id => user.id).pluck(:company_user_id)
        users << user.id
        users = users.present? ? users.uniq : []
        appointments = Appointment.includes(:lead).includes(:user).where(:user_id=>users).where("app_date = ?", date)
      when :employee
        appointments = Appointment.includes(:lead).includes(:user).where(:user_id=>user.id).where("app_date = ?", date)
    end
    return appointments
  end

  def self.fetch_monthly_apptmnt(user, date)
      mth_strt = date.at_beginning_of_month
      mth_end = date.at_end_of_month
      case user.user_role.role_type.to_sym  
      when :admin
        appointments = Appointment.includes(:lead).includes(:user).where("app_date = ?", date)  
      when :company
        users = Company.where(:company_admin_id => user.id).pluck(:company_user_id)
        users << user.id
        users = users.present? ? users.uniq : []
        appointments = Appointment.includes(:lead).includes(:user).where(:user_id=>users).where("app_date > ? and app_date < ?",mth_strt, mth_end)
      when :employee
        appointments = Appointment.includes(:lead).includes(:user).where(:user_id=>user.id).where("app_date > ? and app_date < ?",mth_strt, mth_end)
    end
  end

end
