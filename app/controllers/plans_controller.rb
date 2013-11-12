class PlansController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:new]

  def index
    @plans = Plan.order("price")
  end

  def new
  	rangeId = params[:maxUsers] ? params[:maxUsers] : 1
	@planPerUsers = PlanPerUserRange.where(:user_range_id => rangeId)
  end

end