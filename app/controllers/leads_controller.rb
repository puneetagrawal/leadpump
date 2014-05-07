class LeadsController < ApplicationController
  include LeadsHelper
  skip_before_filter :authenticate_user!, :only => [:index] 
  autocomplete :lead, :email, :full => true
  def index
   
  end

  def edit   
    @lead = Lead.find(params[:id])   
    respond_to do |format|
        format.js 
    end 
  end

  def new 
    hash = Lead.fetchLeadList(current_user) 
    @leads = hash['leads'.to_sym]
    @userList = hash['userList'.to_sym]
    @lead  = Lead.new()
  end

  def create
    if current_user.checkLeadLimit
      @lead = Lead.new(params[:lead])
      @lead.company_id = current_user.id  
      if @lead.save
        user_lead = UserLeads.new(:user_id => current_user.id, :lead_id => @lead.id)
        user_lead.save
        NewsFeed.create(:user_id=>current_user.id, :lead_id=>@lead.id, :description=>"New Data Entry Lead", :feed_date=>Date.today, :action=>"Start")
        LeadNotes.create(:lead_id=>@lead.id,:notes=>params[:lead][:notes],:time_stam=>DateTime.now)
        current_user.saveLeadCount
        AutoResponderRecord.save_respond_message(user_lead, current_user)
        flash[:notice] = "New lead created successfully"
        redirect_to new_lead_path
      else
        hash = Lead.fetchLeadList(current_user) 
        @leads = hash['leads'.to_sym]
        @userList = hash['userList'.to_sym]
        render "new"
      end
    else
      flash[:alert] = "Sorry! your lead creation limit exceeded."
      @lead  = Lead.new()
      hash = Lead.fetchLeadList(current_user) 
      @leads = hash['leads'.to_sym]
      @userList = hash['userList'.to_sym]
      render "new"
    end
  end

  def update  
    @leadUpdate = Lead.find(params[:id]) 
    if @leadUpdate.update_attributes(params["inputs"]["lead"])
      LeadNotes.create(:lead_id=>@leadUpdate.id,:notes=>params["inputs"]["lead"]["notes"],:time_stam=>DateTime.now)
      @lead = Lead.new
    end
    respond_to do |format|
        format.js 
    end
  end

  def delete

  end

  def show
  end

  def leadassign
    company_users = Company.where(:company_admin_id => current_user.id)
    company_users = company_users.pluck(:company_user_id)
    @users = company_users.collect{|user| User.find(user)}
    @users = @users.uniq
    @lead = Lead.find(params[:leadId])  
    respond_to do |format|
      format.js   
    end
end

def createtask
  @lead = Lead.find(params[:leadId])
  @appointment = Appointment.find_by_lead_id(@lead.id)
  @task = ''
  @hour = ''
  @min = ''
  @zone = ''
  if @appointment.present?
    @date = @appointment.app_date_time.strftime("%m/%d/%Y")
    @task = @appointment.task
    @hour = @appointment.app_date_time.hour
    @min = @appointment.app_date_time.min
    if @hour >= 12 
      @zone = "pm"
      @hour = @appointment.app_date_time.hour - 12
    else
      @zone = "am"
    end
  end
  
  @tasklist = ["Schedule call", "Schedule tour", "Schedule sign up"]
  respond_to do |format|
    format.js   
  end
end

def leadassigntouser
  user = User.find(params[:userId])
  lead = Lead.find(params[:leadId])
  userleads = UserLeads.where(:lead_id => lead.id).where('user_id != ?', current_user.id)
  if userleads.present?
    userleads[0].user_id = user.id
    userleads[0].save
  else
    user_lead = UserLeads.new(:lead_id => lead.id, :user_id=>user.id)
    user_lead.save
  end
  user_name = {"name" => user.name}
  respond_to do |format|
    format.json { render json: user_name}
  end
end

# def changeleadstatus
#   @lead = Lead.find(params[:leadId])  
#   #@status = @lead.active ? "Active" : "Inactive"
#   respond_to do |format|
#     format.js 
#   end
# end

def saveleadstatus
  if(params[:urls].include?'company')
    object = User.find(params[:leadId])  
  else
    object = Lead.find(params[:leadId])  
  end
  object.active = params[:status] == "false" ? false : true
  object.save
  status = Lead.checkLeadStatus(object.active)
  logger.debug(status)
  msg = {"status"=>status}
  render json:msg
end

def filterbyname
  if params[:userId].blank?
    hash = Lead.fetchLeadList(current_user) 
    @leads = hash['leads'.to_sym]
  else
    @leads = UserLeads.includes(:lead).where(:user_id=>params[:userId])
  end
  respond_to do |format|
    format.js 
  end
end

def leadsearchfilter
  hash = Lead.fetchLeadList(current_user) 
  leadlist = hash['leads'.to_sym]
  leadlist = leadlist.pluck(:lead_id)
  like = "%#{params[:leadId]}%"
  lead = Lead.where("name ilike ? or lname ilike ? or lead_source ilike ?", like,like,like).where(:id=>leadlist) 
  @leads = UserLeads.includes(:lead).select("distinct(lead_id)").where(:lead_id=>lead)
  respond_to do |format|
    format.js 
  end
end

def getemails
  hash = Lead.fetchLeadList(current_user) 
  leadlist = hash['leads'.to_sym]
  leadlist = leadlist.pluck(:lead_id)
  if params[:term].blank?
   leads = Lead.select("distinct(name)").where(:id=>leadlist) 
   list = leads.map {|l| Hash[id: l.id, label: l.name, name: l.name]}
  else
   like  = "%".concat(params[:term].concat("%"))
   leads = Lead.select("distinct(name)").where("name like ?", like).where(:id=>leadlist) 
   list = leads.map {|l| Hash[id: l.id, label: l.name, name: l.name]}
   if !leads.present?
      leads = Lead.select("distinct(lname)").where("lname like ? ", like).where(:id=>leadlist) 
      list = leads.map {|l| Hash[id: l.id, label: l.lname, name: l.lname]}
   end
   if !leads.present?
      leads = Lead.select("distinct(lead_source)").where("lead_source like ? ", like).where(:id=>leadlist) 
      list = leads.map {|l| Hash[id: l.id, label: l.lead_source, name: l.lead_source]}
   end
 end
 render json: list
end

def socialInviter
end

def saveappointment
  time = DateTime.strptime(params[:time], '%m/%d/%Y %I:%M:%p')
  date = DateTime.strptime(params[:date], '%m/%d/%Y')
  lead = params[:leadId] ? Lead.find(params[:leadId]) : nil
  msg = "Please try again."
  if lead.present?
    appoint = Appointment.find_by_lead_id(lead.id)
    if appoint.present?
      appoint.update_attributes(:task=>params[:task],:app_date_time=>time,:app_date=>date,:user_id=>current_user.id)
    else
      apoint = Appointment.new(:task=>params[:task],:app_date=>date,:app_date_time=>time,:lead_id=>lead.id, :user_id=>current_user.id)  
      if apoint.save
      else
      end      
    end
    NewsFeed.add_appointment_feed(lead, appoint, current_user)
    msg = "Appointment schedule successfully"
  end
  logger.debug("<><<<<<<<<<<<<<<<")
  logger.debug(date)
  @appointments = Appointment.fetch_monthly_apptmnt(current_user, date)
  @appoint_date = @appointments.collect{|app| app.app_date_time.strftime("%m/%d/%Y %I:%M")}
  @appoint_task = @appointments.collect{|app| app.task}
  @appoint_id  = @appointments.collect{|app| app.lead_id}
  data = {"msg" => msg,"app_date"=>@appoint_date, "app_task"=>@appoint_task, "lead_id"=>@appoint_id}
  respond_to do |format|
    format.json { render json: data}
  end
 end

 def add_notes
    time_now = DateTime.now
    lead = Lead.find(params[:id])
    cls = ''
    if !params[:notes].blank? && lead.present?
      if params[:uri] == "home"
        NewsFeed.update_feed_action(lead, "Finish")
      end
      LeadNotes.create(:lead_id=>lead.id,:notes=>params[:notes],:time_stam=>time_now)
      cls = 'read_feed'
    end
    text = create_note_row(lead)
    msg = {"note_row"=>text, "clas" => cls}
    render json:msg
 end

 def read_feed
  feed = NewsFeed.find(params[:feed])
  if feed.present? && params[:uri] == "home"
    NewsFeed.update_feed_action(feed.lead, "Completed")
  end
  msg = {"status"=>"sucess"}
  render json:msg
 end

end
