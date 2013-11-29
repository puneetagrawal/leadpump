class AdminController < ApplicationController
require 'will_paginate/array'

def index
end

def user
 @users = User.all.paginate(:page => params[:page], :per_page => 10)
end

def plan

end

def statistic
@vipleads = VipLead.all
end

def payment
 @users = User.all
end

def user_record
	@users = User.all.paginate(:page => params[:page], :per_page => params[:search_val])
end

def searchUserAc
	like  = "%".concat(params[:term].concat("%"))
    users = User.select("distinct(name)").where(" name ilike ? ", like)
    if !users.present?
      users = User.fetchUserByPlan(like)
      list = users.map {|l| Hash[id: l.id, label: l.subscription.plan_per_user_range.plan.name, name: l.subscription.plan_per_user_range.plan.name]}
    else
      list = users.map {|l| Hash[id: l.id, label: l.name, name: l.name]}
    end
    render json: list
  end

  def usersearchinadmin
  	like  = "%".concat(params[:userId].concat("%"))
  	@users = User.select("distinct(name)").where(" name ilike ? ", like)
    logger.debug(@users.size)
    if !@users.present?
      @users = User.fetchUserByPlan(like)
    end
	respond_to do |format|
		format.js 
	end
  end


end
