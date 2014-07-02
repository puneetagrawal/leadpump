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
	@appoint_date = @appointments.collect{|app| app.app_date_time.strftime("%m/%d/%Y %I:%M")}
	
	@appoint_task = @appointments.collect{|app| app.task}
end

def get_cal_data
	date = Date.new(2014,params[:month].to_i,1)
	@appointments = Appointment.fetch_monthly_apptmnt(current_user, date)
	@appoint_date = @appointments.collect{|app| app.app_date_time.strftime("%m/%d/%Y %I:%M")}
	@appoint_task = @appointments.collect{|app| app.task}
	@appoint_id  = @appointments.collect{|app| app.lead_id}
	msg = {"app_date"=>@appoint_date, "app_task"=>@appoint_task, "lead_id"=>@appoint_id}
    render json: msg
end

end

