class LeadsController < ApplicationController
  def index
    
  end

def edit   
    @lead = Lead.find(params[:id])   
end


def new  
  @leads = []
  case current_user.user_role.to_sym
  when :admin
    @leads = Lead.all
  when :company
    @leads = Lead.where(:company_id =>current_user.id)
  end

  @lead  = Lead.new()

end

def create
  @lead = Lead.new(params[:lead])
  @lead.company_id = current_user.id
  if @lead.save
    flash[:notice] = "New lead created successfully"
    redirect_to lead_index_path
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
end
