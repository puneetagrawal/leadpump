class LeadsController < ApplicationController
  autocomplete :user, :name, :full => true
  def index
    
  end

def edit   
    @lead = Lead.find(params[:id])   
end


def new  
  @leads = []
  case current_user.user_role.role_type.to_sym  
    when :admin
      @leads = Lead.all      
    when :company
      userList = Company.where(:company_admin_id => current_user.id).pluck(:company_user_id)
      userList << current_user.id
      #userList = userList.uniq
      puts userList
      @leads = UserLeads.where(:user_id => userList).uniq
      @leads = @leads.uniq
    when :employee
      @leads = UserLeads.where(:user_id => current_user.id)
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

end
