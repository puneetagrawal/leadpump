class LeadsController < ApplicationController
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
    @leads = UserLeads.where(:user_id =>current_user.id)
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

def getAutoCompleteForLeadAssignment
  respond_to do |format|
    format.json { render json: "check"}
  end
end


end
