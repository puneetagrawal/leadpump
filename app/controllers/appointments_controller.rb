class AppointmentsController < ApplicationController

def new
 @appointments = Appointment.all
 @appointment = Appointment.new(params[:appointment])
 @tym = Hash.new
 @appointments.each do |appointment|
  # debugger
  if @tym.has_key?(appointment.app_time) 
		@tym[appointment.app_time][:appointments][:id] = Hash.new
		@tym[appointment.app_time][:appointments][:id]  = appointment.id
   		@tym[appointment.app_time][:appointments][:name]  = appointment.name
   		@tym[appointment.app_time][:appointments][:phone]  = appointment.phone
   		@tym[appointment.app_time][:appointments][:notes]  = appointment.notes
      logger.debug @tym[appointment.app_time][:appointments][:name]
      logger.debug "+++++++++++++"
   else
   		@tym[appointment.app_time] = Hash.new
   		@tym[appointment.app_time][:appointments] = Hash.new
   		@tym[appointment.app_time][:appointments][:id] = Hash.new
   		@tym[appointment.app_time][:appointments][:id]  = appointment.id
   		@tym[appointment.app_time][:appointments][:name]  = appointment.name
   		@tym[appointment.app_time][:appointments][:phone]  = appointment.phone
   		@tym[appointment.app_time][:appointments][:notes]  = appointment.notes
        logger.debug @tym[appointment.app_time][:appointments][:name]
      logger.debug "**********************"
   end
 end
end

def index
   @appointments = Appointment.all	

end

def create
  @appointment = Appointment.new(params[:appointment])
  date = @appointment.app_date
  debugger
  time = Chronic.parse(@appointment.app_time).strftime("%H:%M")
    if @appointment.save
     	@appointment.update_attributes(:app_time => time, :app_date => date)
        redirect_to appointment_new_path()
    else
        render :nothing
    end
 end


end

