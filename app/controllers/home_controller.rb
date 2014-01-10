
class HomeController < ApplicationController
	require 'httparty'
  skip_before_filter :authenticate_user!, :only => [:pass,:print_pass,:storepassinsession,
    :calculateAmount]
  layout 'company_layout', only: [:pass,:print_pass]

  def index
   if !current_user.isAdmin
     @users = current_user.fetchCompanySalesUsers
     @leads = Lead.fetchTotalLeads(current_user)
     #saletodate = SaleProd.fetchProdDataTotal(current_user)
     saletodate = SaleProd.fetchProdDataUpToDate(current_user, Date.today)
     @gross_values = SaleProd.fetchGrossMap(saletodate)
   else
    redirect_to admin_index_path
   end
 end

 def testsendgrid   
  response = HTTParty.get('https://api.sendgrid.com/api/stats.get.json?api_user=leadpump&api_key=4trading&days=2&category=socailReferring')
  response = response.gsub("[", " ")
  response = response.gsub("]", " ")
  response = response.gsub("{", " ")
  response = response.gsub("}", " ")
  response = response.split(",")[13]
  response = response.split(":")[1]
end

def terms
end

def test
   @companymallitem = current_user.fetchcompanymallitem
end

def privacy
end

def sendmail
  Emailer.sendtestmail().deliver
end 

def fetchhotmailfriends
  logger.debug(params)
  @contacts = params[:email_list]
  respond_to do |format|
    format.js 
  end
end

def fetchfbfreinds
  logger.debug(params[:user_email])
  session[:email_user] = params[:user_email]
  logger.debug(session[:email_user])
  @fbfreinds = params[:info] 
  @fbfreinds = @fbfreinds.sort_by { |hsh| hsh[1]["name"] } 
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
  if((params[:urls].include? 'company') || (params[:urls].include? 'admin')) 
    @user = User.find(params[:leadId])
  else
    @lead = Lead.find(params[:leadId])
  end
  respond_to do |format|
    format.js 
  end
end

def saveleadstatus
  if((params[:urls].include? 'company') || (params[:urls].include? 'admin'))
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
  if((params[:uri].include? 'company') || (params[:uri].include? 'admin'))
   object = User.find(params[:leadId])
   company = User.fetchCompanyUserList(object)
   company << object
   company = company.uniq
   if company.present?
    Lead.assigndeletedleadtocompany(object)
    Appointment.assigndeletedappointmenttocompany(object)
    OptInLead.assignOptinToAdmin(object)
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

  def contacts_callback
    unless request.env['omnicontacts.contacts'].blank?
      @contacts = request.env['omnicontacts.contacts']
    end
  end

  def send_invitation_social
    message="Please join Leadpump "
    email_id=params[:check_invite_email]
    logger.debug email_id.inspect
    mail_invitaion(message,email_id)
    redirect_to "/"
  end

  def pass
    #@company = User.find(2)
    Company.removeAllPrintPassSessions(session)
    user = User.find(params[:id])
    @company = user.fetchCompany
    landpage = LandingPage.where(:user_id=>@company.id).last
    @dayscount = landpage.present? ? landpage.no_of_days.present? ? landpage.no_of_days : 1 : 1
  end

  def print_pass
    @temp = TemporaryData.first
    @down = "true"
    @company = User.find(params[:user])
    @pf = WickedPdf.new.pdf_from_string(render_to_string('home/_printPass.html.erb',:layout=>false))
    respond_to do |format|
      format.pdf do
        send_data @pf, filename: "pass.pdf", type: 'application/pdf', disposition: 'inline'
      end
    end
    #  respond_to do |format|
    #   format.js do
    #     send_data filename: "foo.pdf",
    #               type: "application/pdf",
    #               disposition: "attachment"
    #   end
    # end
  end

  def storepassinsession
    TemporaryData.first.update_attributes(params[:fn].to_sym => params[:val])
    msg = {"success"=>"dd"}
    TemporaryData.first.prg
    respond_to do |format|
      format.json { render json: msg}
    end
  end

  private

  def mail_invitaion(message,email_id)
    unless email_id.blank?
      email_id.each do |email|
        begin
          Emailer.invite_friends(message,email).deliver 
        rescue Exception => e             
        end         
      end
    end
  end

end
