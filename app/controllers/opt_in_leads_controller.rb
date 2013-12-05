class OptInLeadsController < ApplicationController
  
  def index
  	if current_user.isCompany || current_user.isEmployee
  		#users = User.fetchCompanyUserList(current_user)
  		#users = users.present? ? users.collect{|user| user.id} : []
  		#users << current_user.id
		@opt_in_lead = OptInLead.where(:referrer_id=>current_user.id)
	else
		flash[:notice] = "Sorry you are not authorize user for this action"
		redirect_to home_index_path
		return false
	end
  end

  def viewContact
  	@opt_in_lead = OptInLead.find(params[:leadId])
  	respond_to do |format|
        format.js 
    end 
  end
end
