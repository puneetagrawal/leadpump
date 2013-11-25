class AppointmentsController < ApplicationController

def new
 @appointments = Appointment.all
end

def index
   @appointments = Appointment.all	
   @filter_appointment = Appointment.where(:app_date=> params[:appointment_date]).all
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

