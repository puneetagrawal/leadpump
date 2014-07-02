class PlansController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:new]

  def index
    @plans = Plan.order("price")
    
  end

  def new
  	rangeId = params[:maxUsers] ? params[:maxUsers] : 1
  	@user = params[:user].present? ? User.find_by_token(params[:user]) : nil
	  @planPerUsers = PlanPerUserRange.order("id ASC").where(:user_range_id => rangeId)

	  #address = Address.find_by_user_id("#{@user.id}")
	  #logger.debug("S>>>>>>>>>>>>>>>>>>>sdfsdfd")
	  #logger.debug(address)
	  #Emailer.send_user_info_to_admin(@user, "", address).deliver
  end

end