class LeadsController < ApplicationController
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
    @date = @appointment.appdateTime.strftime("%Y-%m-%d")
    @task = @appointment.task
    @hour = @appointment.appdateTime.hour
    @min = @appointment.appdateTime.min
    if @hour >= 12 
      @zone = "pm"
      @hour = @appointment.appdateTime.hour - 12
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

def changeleadstatus
  @lead = Lead.find(params[:leadId])  
  #@status = @lead.active ? "Active" : "Inactive"
  respond_to do |format|
    format.js 
  end
end

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
  @leads = UserLeads.where(:user_id=>params[:userId])
  respond_to do |format|
    format.js 
  end
end

def leadsearchfilter
  hash = Lead.fetchLeadList(current_user) 
  leadlist = hash['leads'.to_sym]
  leadlist = leadlist.pluck(:lead_id)
  lead = Lead.where("name = ? or lname = ? or lead_source = ?", params[:leadId],params[:leadId],params[:leadId]).where(:id=>leadlist) 
  @leads = UserLeads.select("distinct(lead_id)").where(:lead_id=>lead)
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
 logger.debug(list)
 render json: list
end

def socialInviter
end

def saveappointment
  time = DateTime.strptime(params[:time], '%Y-%m-%d %I:%M:%p')
  logger.debug(time)
  lead = params[:leadId] ? Lead.find(params[:leadId]) : nil
  msg = "Please try again."
  if lead.present?
    appoint = Appointment.find_by_lead_id(lead.id)
    if appoint.present?
      appoint.update_attributes(:task=>params[:task],:appdateTime=>time)
    else
      apoint = Appointment.create(:task=>params[:task],:appdateTime=>time,:lead_id=>lead.id)  
    end
    
    msg = "Appointment schedule successfully"
  end
  data = {"msg" => msg}
  respond_to do |format|
    format.json { render json: data}
  end
 end

end
