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
	@leads = UserLeads.includes(:lead).where("leads.lead_source = ?", "vip").paginate(:page => params[:page], :per_page => 10)
  @stats = Stats.all.paginate(:page => params[:page], :per_page => 10, :order => "created_at DESC")
  respond_to do |format|
    format.html
    format.js
  end
end

def payment
 @users = User.fetchPaidUser.paginate(:page => params[:page], :per_page => params[:search_val])
end

def user_record
	@users = User.all.paginate(:page => params[:page], :per_page => params[:search_val])
end

def user_per_plan
  if params[:plan_id].present?
    planname = Plan.find(params[:plan_id])
    @users = User.fetchUserByPlan(planname)
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
  	@users = User.where(" name ilike ? ", like)
    if !@users.present?
      plan = Plan.where("name ilike ?", like)
      @users = User.fetchUserByPlan(plan)
    end
	respond_to do |format|
		format.js 
	end
  end

   
  def filter_vip
  f_dt = params[:vip_from_date].present? ? params[:vip_from_date] : ''
  t_dt = params[:vip_to_date].present? ? params[:vip_to_date] : ''
  if(f_dt != '' && t_dt != '')
    f_dt = Date.strptime(f_dt, "%m/%d/%Y")
    t_dt = Date.strptime(t_dt, "%m/%d/%Y")
    @leads = UserLeads.includes(:lead).where("leads.lead_source = ? and leads.created_at >= ? and leads.created_at <= ?","vip",f_dt,t_dt)
  else
    @leads = UserLeads.includes(:lead).where("leads.lead_source = ?","vip")
  end
	respond_to do |format|    
  		format.js 
	end
end

def filter_payment
  f_dt = params[:payment_from_date].present? ? params[:payment_from_date] : ''
  t_dt = params[:payment_to_date].present? ? params[:payment_to_date] : ''
  if(f_dt != '' && t_dt != '')
    f_dt = Date.strptime(f_dt, "%m/%d/%Y")
    t_dt = Date.strptime(t_dt, "%m/%d/%Y")
    @users = Subscription.includes(:user).where("subscriptions.payment IS NOT NULL and subscriptions.created_at >= ? and subscriptions.created_at <= ?",f_dt,t_dt)
  else
    @users = User.fetchPaidUser
  end
  respond_to do |format|    
    format.js 
  end
end

def search_vip
	leads = Lead.where(:lead_source => "vip")
	if params[:term].blank?
		leads = Lead.select("distinct(name)").where(:id => leads) 
		list = leads.map {|l| Hash[id: l.id, label: l.name, name: l.name]}
	else
   like  = "%".concat(params[:term].concat("%"))
   leads = Lead.select("distinct(name)").where("name like ?", like).where(:id => leads)
   list = leads.map {|l| Hash[id: l.id, label: l.name, name: l.name]}
   logger.debug("************************")
   if !leads.present?
      logger.debug(">>>>>>>>>>>>>>>>>>")
      userleads = UserLeads.includes(:lead).where("leads.lead_source = ?", "vip")
      associates = User.select("distinct(name)").where("name like ? ", like).where(:id=> userleads.map(&:user_id))
      list = associates.map {|a| Hash[id: a.id, label: a.name, name: a.name]}
    end
  end
  render json: list
end

  def search_payment
  @users = User.fetchPaidUser
  if params[:term].blank?
    @users = User.select("distinct(name)").where(:id => @users)
    list = @users.map {|u| Hash[id: u.user.id, label: u.user.name, name: u.user.name]}
  else
     like  = "%".concat(params[:term].concat("%"))
     @users = User.select("distinct(name)").where("name like ?", like).where(:id => @users)
     list = @users.map {|u| Hash[id: u.id, label: u.name, name: u.name]}
   end
   render json: list
  end

  def vipleadsearchadminfilter
    like  = "%".concat(params[:viplead].concat("%"))
    @leads = UserLeads.includes(:lead).where("leads.lead_source = ? and leads.name ilike ?", "vip", like)
    if @leads.blank?
      @leads = UserLeads.includes(:lead).where("leads.lead_source = ?", "vip")
    end
    respond_to do |format|
      format.js { render "filter_vip" }
    end
  end
  
  def paymentsearchfilter
    like  = "%".concat(params[:user].concat("%"))
    @users = Subscription.includes(:user).where("users.name ilike ? and subscriptions.payment IS NOT NULL",like)
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
    @stat = Stats.find_by_user_id(params[:inviteid])
    respond_to do |format|
      format.js
    end
  end
end
