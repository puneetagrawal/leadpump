class LeadsController < ApplicationController
  autocomplete :lead, :email, :full => true
  def index
  end

  def edit   
    @lead = Lead.find(params[:id])   
  end


  def new  
    @leads = []
    case current_user.user_role.role_type.to_sym  
    when :admin
      @leads = UserLeads.includes(:lead).all     
    when :company
      @userList = Company.where(:company_admin_id => current_user.id).pluck(:company_user_id)
      @userList << current_user.id
      @leads = UserLeads.includes(:lead).where(:user_id => @userList)
      @userList = @userList.collect{|user| User.find(user)}
    when :employee
      @leads = UserLeads.includes(:lead).where(:user_id => current_user.id)
    end
    @lead  = Lead.new()
  end

  def create
    @lead = Lead.new(params[:lead])
    @lead.company_id = current_user.id  
    if @lead.save
      user_lead = UserLeads.new(:user_id => current_user.id, :lead_id => @lead.id)
      user_lead.save
      flash[:notice] = "New lead created successfully"
      redirect_to new_lead_path
    else
      render "new"
    end
  end

  def update  
    @lead = Lead.find(params[:id]) 
    @lead.update_attributes(params[:lead])
    redirect_to new_lead_path
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
    format.js   # leadAssignToUserTemplate.js.erb
  end
end

def leadassigntouser
  user = User.find(params[:userId])
  lead = Lead.find(params[:leadId])
  user_lead = UserLeads.new(:lead_id => lead.id, :user_id=>user.id)
  user_lead.save
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
  lead = Lead.find(params[:leadId])
  lead.active = params[:status] == "false" ? false : true
  lead.save
  status = checkLeadStatus(lead.id)
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
  @leads = UserLeads.where(:lead_id=>params[:leadId])
  respond_to do |format|
    format.js 
  end
end

def getemails
  if params[:term]
   like  = "%".concat(params[:term].concat("%"))
   leads = Lead.where("email like ?", like)
 else
   leads = Lead.all
 end
 list = leads.map {|l| Hash[id: l.id, label: l.email, name: l.email]}
 render json: list
end

end
