class AppointmentsController < ApplicationController

def new
 @appointments = Appointment.all
 @appointment = Appointment.new(params[:appointment])
 tym = Hash.new
 @appointments.each do |appointment|
 	 
   if tym.has_key?(appointment.app_time) 
		tym[appointment.app_time][:appointments][:id] = Hash.new
		tym[appointment.app_time][:appointments][:id]  = appointment.id
   		tym[appointment.app_time][:appointments][:id][:name]  = appointment.name
   		tym[appointment.app_time][:appointments][:id][:phone]  = appointment.phone
   		tym[appointment.app_time][:appointments][:id][:notes]  = appointment.notes
   else
   		tym[appointment.app_time] = Hash.new
   		tym[appointment.app_time][:appointments] = Hash.new
   		tym[appointment.app_time][:appointments][:id] = Hash.new
   		tym[appointment.app_time][:appointments][:id]  = appointment.id
   		tym[appointment.app_time][:appointments][:id][:name]  = appointment.name
   		tym[appointment.app_time][:appointments][:id][:phone]  = appointment.phone
   		tym[appointment.app_time][:appointments][:id][:notes]  = appointment.notes
   end
 end
  
  
end

def index
   @appointments = Appointment.all	

end

def create
  @appointment = Appointment.new(params[:appointment])
  time = Chronic.parse(@appointment.app_time).strftime("%H:%M")
    if @appointment.save
     	@appointment.update_attributes(:app_time => time)
        redirect_to appointment_new_path()
    else
        render :nothing
    end
 end

 # def hash_time

 # end

end

