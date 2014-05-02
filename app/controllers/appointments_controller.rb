class AppointmentsController < ApplicationController

def new
  @appointments = Appointment.fetchuserappointments(current_user, Date.today)
end

def index
 
end

def filter_app
  date = DateTime.strptime(params[:appointment_date], '%m/%d/%Y')
  @appointments = Appointment.fetchuserappointmentFilter(current_user, date)
end

def calander
	@appointments = Appointment.fetch_monthly_apptmnt(current_user, Date.today)
	logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>#{@appointments.size}"
	# @appoint_date = @appointments.collect{|app| app.app_date.strftime("%m/%d/%Y")}
	
	@appoint_date = @appointments.collect{|app| app.app_date_time.strftime("%m/%d/%Y %I:%M%p")}
logger.debug "????????????????????????"
	logger.debug @appointments.app_date_time.strftime("%m/%d/%Y %I:%M%p")
	@appoint_task = @appointments.collect{|app| app.task}
end

end

