class AppointmentsController < ApplicationController

def new
 case current_user.user_role.role_type.to_sym  
      when :admin
        @appointments = Appointment.all   
      when :company
        users = Company.where(:company_admin_id => current_user.id).pluck(:company_user_id)
        users << current_user.id
        users = users.present? ? users.uniq : []
        @appointments = Appointment.where(:user_id=>users)
      when :employee
        @appointments = Appointment.where(:user_id=>current_user.id)
    end
    ids  = @appointments.present? ? @appointments.pluck(:id) : []

   @filter_appointment = Appointment.where(:app_date=> params[:appointment_date]).where(:id=>ids)
end

def index
  # case user.user_role.role_type.to_sym  
  #     when :admin
  #       @appointments = Appointment.all   
  #       logger.debug @appointments.inspect
  #       logger.debug "++++++++++++++++"   
  #     when :company
  #       users = Company.where(:company_admin_id => user.id).pluck(:company_user_id)
  #       @appointments = Appointment.where(:user_id=>users)
  #       logger.debug @appointments.inspect
  #       logger.debug "*****************"
  #     when :employee
  #       @appointments = Appointment.where(:user_id=>current_user.id)
  #       logger.debug @appointments.inspect
  #       logger.debug "________________________"
  #   end
  #    logger.debug @appointments.inspect
  #    logger.debug "@@@@@@@@@"
  #   ids  = @appointments.present? ? @appointments.pluck(:id) : []

  #  @filter_appointment = Appointment.where(:app_date=> params[:appointment_date]).where(:id=>ids)
end

def create
  @appointment = Appointment.new(params[:appointment])
  date = @appointment.app_date if @appointment.app_date.present?
  time = Chronic.parse(@appointment.app_time).strftime("%H:%M") if @appointment.app_time.present?
    if @appointment.save
     	@appointment.update_attributes(:app_time => time, :app_date => date)
      redirect_to appointment_new_path()
    else
      @appointments = Appointment.all
        render :new
    end
 end

 def filter_app
  @filter_appointment = Appointment.where(:app_date=> params[:appointment_date]).all
 end

 

end

