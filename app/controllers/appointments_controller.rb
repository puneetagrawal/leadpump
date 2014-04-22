class AppointmentsController < ApplicationController

def new
  @appointments = Appointment.fetchuserappointments(current_user, DateTime.now)
end

def index
 
end

def filter_app
  date = DateTime.strptime(params[:appointment_date], '%m/%d/%Y')
  @appointments = Appointment.fetchuserappointmentFilter(current_user, date)
end

def calander
	@appointments = Appointment.fetchuserappointments(current_user, DateTime.now)
	logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>"
	if @appointments.present?
		@appointments.each do |a|
			if a.app_date_time.present? && a.app_date.present?
				# logger.debug "<<<<<<<<<<<<<<<"
				# logger.debug a.app_date_time.strftime("%I:%M %p")
				# logger.debug a.app_date.strftime("%m/%d/%Y")
				# logger.debug a.user.name.humanize if a.user.present?
				# logger.debug a.lead.name
				# logger.debug a.task
			end
		end
	end
end

end

