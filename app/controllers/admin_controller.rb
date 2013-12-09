class AdminController < ApplicationController
before_filter :authenticate
require 'will_paginate/array'

def index
end

def user
 @users = User.paginate(:page => params[:page], :per_page => 10)
end

def plan
   @planlist = []
   plan = Plan.all
   plan.each do|p|
     @planlist << PlanPerUserRange.where(:plan_id => p.id)
   end
end

def statistic
	@leads = Lead.where(:lead_source => "vip").paginate(:page => params[:page], :per_page => 1, :order => "created_at DESC")
  @stats = Stats.all.paginate(:page => params[:page], :per_page => 1, :order => "created_at DESC")
  respond_to do |format|
    format.html
    format.js
  end
end

def statisticsearchfilter
  @leads = Lead.where(:lead_source => "vip")
  respond_to do |format|
    format.js { render "filter_vip" }
  end
end

def payment
 @users = User.order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
end

def userpaymentsearchfilter
  @users = User.all
  respond_to do |format|
    format.js { render "paymentsearchfilter" }
  end
end

def user_record
	@users = User.all.paginate(:page => params[:page], :per_page => params[:search_val])
end

def user_per_plan
  if params[:plan_id].present?
    @plan = Plan.find(params[:plan_id])
    @ppurs = PlanPerUserRange.where(:plan_id => @plan).pluck(:id)
    @subs = Subscription.where(:plan_per_user_range_id => @ppurs)
    @users = @subs.collect { |sub| User.find(sub.user)} 
  else
    @users = User.all
  end
  respond_to do |format|
      format.js
  end
end

def destroy
  # @user = User.find(params[:search_user])
  
  # @user.destroy
  # redirect_to admin_user_path 
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

def filter_payment
  @users = User.scoped
  @filter_payments = @users.where(:created_at => (params[:payment_from_date].to_date)..(params[:payment_to_date].to_date))
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
     	userleads = UserLeads.where(:lead_id => leads)
      associates = User.select("distinct(name)").where("name like ? ", like).where(:id=> userleads.map(&:user_id))
      list = associates.map {|a| Hash[id: a.id, label: a.name, name: a.name]}
    end
  end
  render json: list
end

  def search_payment
  @users = User.all
  #@users = @users.present? ? @users.pluck(:id) : []
  if params[:term].blank?
    @users = User.select("distinct(name)").where(:id => @users) 
    list = @users.map {|u| Hash[id: u.id, label: u.name, name: u.name]}
  else
     like  = "%".concat(params[:term].concat("%"))
     @users = User.select("distinct(name)").where("name like ?", like).where(:id => @users)
     list = @users.map {|u| Hash[id: u.id, label: u.name, name: u.name]}
   end
   render json: list
  end

  def vipleadsearchadminfilter
    leads = Lead.where(:lead_source => "vip").pluck(:id)
    @leads = Lead.where("name = ?", params[:viplead]).where(:id=> leads)
    if @leads.blank?
      @users = User.where("name like ?", params[:viplead])
      @userleads = UserLeads.where(:user_id => @users)
      @leads = Lead.where(:id => @userleads ).where(:lead_source => "vip")
    end
    respond_to do |format|
      format.js { render "filter_vip" }
    end
  end
  
  def paymentsearchfilter
    @users = User.all
    @users = User.where("name = ?", params[:user]).where(:id => @users)
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

  def authenticate
    if !current_user.isAdmin 
      flash[:notice] = "Sorry! you are not authorize user to perform this action."
      redirect_to home_index_path
      return false
    end
  end

  def change_user_status
    user = User.find(params[:id])
    if user.active == true
      user.active = false
    else
      user.active = true
    end
    user.save!
    @users = User.all.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.js
    end      
  end

  def invitestatsbyadmin
    @users = UserLeads.where(:lead_id => params[:inviteid]).pluck(:user_id)
    @stat = Stats.where(:user_id => @users).first
    respond_to do |format|
      format.js
    end
  end
end
