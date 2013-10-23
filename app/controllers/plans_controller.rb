class PlansController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:new]

  def index
    @plans = Plan.order("price")
  end

  def new
	@plans = Plan.order("price")
	
  end
end