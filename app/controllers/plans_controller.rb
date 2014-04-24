class PlansController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:new]

  def index
    @plans = Plan.order("price")
  end

  def new
  	rangeId = params[:maxUsers] ? params[:maxUsers] : 1
  	@user = params[:user]
	@planPerUsers = PlanPerUserRange.order("id ASC").where(:user_range_id => rangeId)
  end

end