class AdminController < ApplicationController
require 'will_paginate/array'

def index
end

def user
 @users = User.all.paginate(:page => params[:page], :per_page => 10)
end

def plan
   @planlist = []
   plan = Plan.all
   plan.each do|p|
     @planlist << PlanPerUserRange.where(:plan_id => p.id)
   end
end

def statistic
	@leads = Lead.where(:lead_source => "vip")
end

def payment
 @users = User.all
end

def user_record
	@users = User.all.paginate(:page => params[:page], :per_page => params[:search_val])
end

def destroy
  @user = User.find(params[:search_user])
  @user.destroy
  redirect_to admin_user_path 
end

def searchUserAc
  like  = "%".concat(params[:term].concat("%"))
    users = User.select("distinct(name)").where(" name ilike ? ", like)
    if !users.present?
      users = Plan.where("name ilike ?", like)
      list = users.map {|l| Hash[label: l.name, name: l.name]}
    else
      list = users.map {|l| Hash[label: l.name, name: l.name]}
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
  
  def filter_vip
	@leads = Lead.where(:lead_source => "vip")
	@filter_vips = @leads.where(:created_at => params[:vip_from_date]..params[:vip_to_date])
	respond_to do |format|    
  		format.js 
	end
end

def search_vip
	leads = Lead.where(:lead_source => "vip")
	leads = leads.present? ? leads.pluck(:id) : []
	if params[:term].blank?
		leads = Lead.select("distinct(name)").where(:id => leads) 
		list = leads.map {|l| Hash[id: l.id, label: l.name, name: l.name]}
	else
     like  = "%".concat(params[:term].concat("%"))
     leads = Lead.select("distinct(name)").where("name like ?", like).where(:id => leads)
     list = leads.map {|l| Hash[id: l.id, label: l.name, name: l.name]}
     if !leads.present?
     	leads = Lead.where(:lead_source => "vip")
     	leads = UserLeads.where(:lead_id => leads)
     	users = User.where(:id => leads)
        associates = User.select("distinct(name)").where("name like ? ", like).where(:id=>users)
        list = associates.map {|a| Hash[id: a.id, label: a.name, name: a.name]}
     end
   end
   render json: list
  end

  def vipleadsearchadminfilter
    leads = Lead.where(:lead_source => "vip").pluck(:id)
    @leads = Lead.where("name = ?", params[:viplead]).where(:id=> leads)
    respond_to do |format|
      format.js 
    end
  end

  def editplanbyadmin
    @plans = PlanPerUserRange.find(params[:planid])
    respond_to do |format|
      format.js 
    end
  end
  def setunlimited
    @plan = PlanPerUserRange.find(params[:plid])
    if @plan.present?
      @plan.plan.lead_management = "unlimited"
      @plan.plan.save
      msg = "Set Unlimited Successfully"
    else
      msg = "Something went wrong. Please try later."
    end
    message = {"msg" => msg}
    respond_to do |format|
      format.json { render json: message}
    end
  end

  def updateplan
    @plan = PlanPerUserRange.find(params[:plid])
    if @plan.present?
      unless params[:price].blank?
       @plan.update_attributes(:price=>params[:price])
      end
      unless params[:leads].blank?
        @plan.plan.update_attributes(:lead_management=>params[:leads])
      end
      msg = "Set Unlimited Successfully"
    else
      msg = "Something went wrong. Please try later."
    end
    message = {"msg" => msg}
    respond_to do |format|
      format.json { render json: message}
    end
  end

end
