
class HomeController < ApplicationController
	require 'httparty'
  skip_before_filter :authenticate_user!, :only => [:calculateAmount, :terms, :welcome]

  def index
   @user = User.new
   @picture_user = Picture.fetchCompanyLogo(current_user.id)
   @picture = Picture.new
 end

 def testsendgrid   
  response = HTTParty.get('https://api.sendgrid.com/api/stats.get.json?api_user=leadpump&api_key=4trading&days=2&category=socailReferring')
  #response = "Hiiiiiii"
  #RestClient.get 'http://example.com/resource', {:params => {:id => 50, 'foo' => 'bar'}}
  #puts ">>>>>>>>>>>>>>>>>>>>>>>" + response
  logger.debug(response)

  response = response.gsub("[", " ")
  response = response.gsub("]", " ")
  response = response.gsub("{", " ")
  response = response.gsub("}", " ")
  response = response.split(",")[13]
  response = response.split(":")[1]
  
  logger.debug(response)
end

def terms
end

def sendmail
  Emailer.sendtestmail().deliver
end 


def fetchfbfreinds
  @fbfreinds = params[:info]  
  respond_to do |format|
    format.js 
  end
end


def welcome
end

def calculateAmount
  @msg = User.signUpAmount(params[:plan_per_user_range], params[:du], params[:dp])
  respond_to do |format|
    format.json { render json: @msg}
  end
end  

def fillpopupcontent
  if params[:act] == 'leadpopup'
    @lead = Lead.find(params[:id])
  elsif params[:act] == 'userpopup'
    @user = User.find(params[:id])
  end
  respond_to do |format|
    format.js 
  end
end

def changestatus
  if(params[:urls].include? 'company')
    @user = User.find(params[:leadId])
  else
    @lead = Lead.find(params[:leadId])
  end
  respond_to do |format|
    format.js 
  end
end

def saveleadstatus
  if(params[:urls].include?'company')
    object = User.find(params[:leadId])  
    object.active = params[:status] == "false" ? false : true
    status = Lead.checkLeadStatus(object.active)
  else
    object = Lead.find(params[:leadId])  
    object.status = params[:status]
    status = params[:status]
  end
  object.save
  
  msg = {"status"=>status}
  render json:msg
end

def deleteRowByajax
  if params[:uri].include?'company'
   object = User.find(params[:leadId])
   company = Company.where(:company_user_id=>object.id)
   Lead.assigndeletedleadtocompany(object)
   Appointment.assigndeletedappointmenttocompany(object)
   OptInLead.assignOptinToAdmin(object)
   if company.present?
    company.each do|user|
      user.destroy
    end
  end
else
 object = Lead.find(params[:leadId])
 if object.present?
  userleads = UserLeads.where(:lead_id=>object.id)
  userleads.each do|userlead|
    userlead.destroy
  end
end
end
if object.destroy
  msg = {"msg"=>"successfull"}
else
  msg = {"msg"=>"successfull"}
end
respond_to do |format|
  format.json { render json: msg}
end
end

# def contacts_callback
#   @contacts = request.env['omnicontacts.contacts']
#   @user = request.env['omnicontacts.user']
#   puts "List of contacts of #{user[:name]} obtained from #{params[:importer]}:"
#   @contacts.each do |contact|
#     puts "Contact found: name => #{contact[:name]}, email => #{contact[:email]}"
#   end
# end

def failure
  logger.debug "p;;;;;;;;;;;;;;;;;;;"
end

  def contacts_callback
    logger.debug "pppppppppppppppppppppp"
    @contacts = request.env['omnicontacts.contacts']
    logger.debug @contacts.inspect
    respond_to do |format|
      format.html
    end
  end

end
