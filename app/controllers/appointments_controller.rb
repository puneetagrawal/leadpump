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

end

