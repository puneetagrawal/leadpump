
class AdminController < ApplicationController
before_filter :authenticate
require 'will_paginate/array'

def index
end

def user
  @users = User.paginate(:page => params[:page], :per_page => 10, :order => "created_at DESC")
  @admin = User.where(:role_id => 1).count
  @company = User.where(:role_id => 2).count
  @employee = User.where(:role_id => 3).count
  @n_user = User.where(:role_id => 4).count
  respond_to do |format|
     format.html
     format.js
  end
end

def plan
   @planlist = []
   plan = Plan.all
   plan.each do|p|
     @planlist << PlanPerUserRange.where(:plan_id => p.id)
   end
end

def statistic
	@leads = UserLeads.includes(:lead).where("leads.lead_source = ?", "vip").paginate(:page => params[:page], :per_page => 10, :order => "leads.created_at DESC")
  @stats = Stats.all.paginate(:page => params[:page], :per_page => 10, :order => "created_at DESC")
end

def payment
  @users = User.fetchPaidUser.paginate(:page => params[:page], :per_page => 10, :order => "created_at DESC")
  respond_to do |format|
    format.html
    format.js
 end
end

def user_record
	@users = User.all.paginate(:page => params[:page], :per_page => params[:search_val], :order => "created_at DESC")
  respond_to do |format|
    format.js { render "user" }
 end
end

def user_per_plan
  if params[:plan_id].present?
    planname = Plan.find(params[:plan_id])
    if params[:userid].present?
      @users = User.where(:id => params[:userid]).fetchUserByPlan(planname).paginate(:page => params[:page], :per_page => params[:userno], :order => "created_at DESC")
    else
      @users = User.fetchUserByPlan(planname).paginate(:page => params[:page], :per_page => params[:userno], :order => "created_at DESC")
    end
  else
    @users = User.all.paginate(:page => params[:page], :per_page => params[:userno], :order => "created_at DESC")
  end
  respond_to do |format|
      format.js { render "user" }
  end
end

def user_per_cmpy
  if params[:userid].present?
    @users = []
    user = User.find(params[:userid])
    if params[:plan_id].present?
      planname = Plan.find(params[:plan_id])
      @cmpyusers = User.fetchCompanyUserList(user)
      @cmpyusers << user
      @cmpyusers = @cmpyusers.map(&:id)
      @planusers = User.fetchUserByPlan(planname).map(&:id)
      @users = @cmpyusers & @planusers
      @users = User.where(:id => @users.uniq)
      @users = @users.present? ? @users.paginate(:page => params[:page], :per_page => params[:userno], :order => "created_at DESC") : [] 
    else
      @users = User.fetchCompanyUserList(user).paginate(:page => params[:page], :per_page => params[:userno], :order => "created_at DESC")
      @users << user
    end
  else
    @users = User.paginate(:page => params[:page], :per_page => params[:userno], :order => "created_at DESC")
  end  
  respond_to do |format|
    format.js { render "user" }
  end
end

def adminfilter
  if params[:userid].present?
    @users = []
    user = User.find(params[:userid])
    if params[:plan_id].present?
      planname = Plan.find(params[:plan_id])
      @cmpyusers = User.fetchCompanyUserList(user)
      @cmpyusers << user
      @cmpyusers = @cmpyusers.map(&:id)
      @planusers = User.fetchUserByPlan(planname).map(&:id)
      @users = @cmpyusers & @planusers
      @users = User.where(:id => @users.uniq)
      @users = @users.present? ? @users.paginate(:page => params[:page], :per_page => params[:userno], :order => "created_at DESC") : [] 
    else
      @users = User.fetchCompanyUserList(user).paginate(:page => params[:page], :per_page => params[:userno], :order => "created_at DESC")
      @users << user
    end
  elsif params[:plan_id].present?
    planname = Plan.find(params[:plan_id])
    if params[:userid].present?
      @users = User.where(:id => params[:userid]).fetchUserByPlan(planname).paginate(:page => params[:page], :per_page => params[:userno], :order => "created_at DESC")
    else
      @users = User.fetchUserByPlan(planname).paginate(:page => params[:page], :per_page => params[:userno], :order => "created_at DESC")
    end
  else
    @users = User.paginate(:page => params[:page], :per_page => params[:userno], :order => "created_at DESC")
  end
  respond_to do |format|
    format.js { render "user" }
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
  	@users = User.where(" name ilike ? ", like).paginate(:page => params[:page], :per_page => 10, :order => "created_at DESC")
    if !@users.present?
      plan = Plan.where("name ilike ?", like)
      @users = User.fetchUserByPlan(plan).paginate(:page => params[:page], :per_page => 10, :order => "created_at DESC")
    end
  	respond_to do |format|
  		format.js { render "user" }
  	end
  end

   
  def filter_vip
  f_dt = params[:vip_from_date].present? ? params[:vip_from_date] : ''
  t_dt = params[:vip_to_date].present? ? params[:vip_to_date] : ''
  if(f_dt != '' && t_dt != '')
    f_dt = Date.strptime(f_dt, "%m/%d/%Y")
    t_dt = Date.strptime(t_dt, "%m/%d/%Y")
    @leads = UserLeads.includes(:lead).where("leads.lead_source = ? and leads.created_at >= ? and leads.created_at <= ?","vip",f_dt,t_dt).paginate(:page => params[:page], :per_page => 10, :order => "leads.created_at DESC")
  else
    @leads = UserLeads.includes(:lead).where("leads.lead_source = ?","vip").paginate(:page => params[:page], :per_page => 10, :order => "leads.created_at DESC")
  end
	respond_to do |format|    
  	format.js 
	end
end

def filter_invite
  f_dt = params[:invite_from_date].present? ? params[:invite_from_date] : ''
  t_dt = params[:invite_to_date].present? ? params[:invite_to_date] : ''
  if(f_dt != '' && t_dt != '')
    f_dt = Date.strptime(f_dt, "%m/%d/%Y")
    t_dt = Date.strptime(t_dt, "%m/%d/%Y")
    @stats = Stats.where("created_at >= ? and created_at <= ?", f_dt,t_dt).paginate(:page => params[:page], :per_page => 10, :order => "created_at DESC")
  else
    @stats = Stats.all.paginate(:page => params[:page], :per_page => 10, :order => "created_at DESC")
  end
  respond_to do |format|    
    format.js 
  end
end

 def filter_user
  t_dt = params[:user_to_date].present? ? params[:user_to_date] : ''
  f_dt = params[:user_from_date].present? ? params[:user_from_date] : ''
  if(f_dt != '' && t_dt != '')
    f_dt = Date.strptime(f_dt, "%m/%d/%Y")
    t_dt = Date.strptime(t_dt, "%m/%d/%Y")
    @users = User.where("created_at >= ? and created_at <= ?", f_dt, t_dt ).paginate(:page => params[:page], :per_page => 10, :order => "created_at DESC") 
    logger.debug f_dt
    logger.debug t_dt
    logger.debug @users
    logger.debug("<<<<<<<<<<<<<<<<<<")
  else
    @users = User.paginate(:page => params[:page], :per_page => 10, :order => "created_at DESC") 
  end
  respond_to do |format|    
    format.js { render "user" }
  end
end

def filter_payment
  f_dt = params[:payment_from_date].present? ? params[:payment_from_date] : ''
  t_dt = params[:payment_to_date].present? ? params[:payment_to_date] : ''
  if(f_dt != '' && t_dt != '')
    f_dt = Date.strptime(f_dt, "%m/%d/%Y")
    t_dt = Date.strptime(t_dt, "%m/%d/%Y")
    @users = Subscription.includes(:user).where("subscriptions.payment IS NOT NULL and subscriptions.created_at >= ? and subscriptions.created_at <= ?",f_dt,t_dt).paginate(:page => params[:page], :per_page => 10, :order => "users.created_at DESC")
  else
    @users = User.fetchPaidUser.paginate(:page => params[:page], :per_page => 10, :order => "created_at DESC")
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
   leads = Lead.select("distinct(name)").where("name ilike ?", like).where(:id => leads)
   list = leads.map {|l| Hash[id: l.id, label: l.name, name: l.name]}
   if !leads.present?
      userleads = UserLeads.includes(:lead).where("leads.lead_source = ?", "vip")
      associates = User.select("distinct(name)").where("name ilike ? ", like).where(:id=> userleads.map(&:user_id))
      list = associates.map {|a| Hash[id: a.id, label: a.name, name: a.name]}
      if associates.empty?
        users = User.where(:id => userleads.map(&:user_id))
        companies = users.collect { |u| u.fetchCompany }
        list = companies.map {|c| Hash[id: c.id, label: c.name, name: c.name]}
      end
    end
  end
  render json: list
end

  def search_payment
    @paidusers = User.fetchPaidUser.pluck(:user_id)
    if params[:term].blank?
      @users = User.select("distinct(name)").where(:id => @paidusers)
      list = @users.map {|u| Hash[id: u.id, label: u.name, name: u.name]}
    else
      like  = "%".concat(params[:term].concat("%"))
      @users = User.select("distinct(name)").where("name ilike ?", like).where(:id => @paidusers)
      list = @users.map {|u| Hash[id: u.id, label: u.name, name: u.name]}
    end
    render json: list
  end

  def invitelist
    if params[:term].blank?
      stats = Stats.select("distinct(source)")
      list.map {|s| Hash[id: s.id, label: s.source, name: s.source]}
    else
      like = "%".concat(params[:term].concat("%"))
      stats = Stats.select("distinct(source)").where("source ilike ?", like)
      list = stats.map {|s| Hash[id: s.id, label: s.source, name: s.source]}
    end
    render json: list      
  end

  def vipleadsearchadminfilter
    like  = "%".concat(params[:viplead].concat("%"))
    @leads = UserLeads.includes(:lead).where("leads.lead_source = ? and leads.name ilike ?", "vip", like).paginate(:page => params[:page], :per_page => 10, :order => "leads.created_at DESC")
    @users = UserLeads.includes(:user).includes(:lead).where("users.name ilike ? and leads.lead_source= ?",like,"vip")
    @userid = @users.collect { |u| u.user_id }
    @company = Company.where(:company_admin_id => @userid.uniq).pluck(:id).paginate(:page => params[:page], :per_page => 10, :order => "created_at DESC")
    if @leads.blank?
      if @company.present? 
        @leads= UserLeads.where(:user_id => @company)
      else
        @leads= @users.paginate(:page => params[:page], :per_page => 10, :order => "leads.created_at DESC")
      end
    end
    respond_to do |format|
      format.js 
    end
  end
  
  def paymentsearchfilter
    like  = "%".concat(params[:user].concat("%"))
    @users = Subscription.includes(:user).where("users.name ilike ? and subscriptions.payment IS NOT NULL",like).paginate(:page => params[:page], :per_page => 10, :order => "users.created_at DESC")
    respond_to do |format|
      format.js { render "filter_payment" }
    end
  end

  def invitesearchfilter
    like = "%".concat(params[:stat].concat("%"))
    @stats = Stats.where("source ilike ?", like).paginate(:page => params[:page], :per_page => 10, :order => "created_at DESC")
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

  def invitestatsbyadmin
    @stat = Stats.find_by_user_id(params[:inviteid])
    respond_to do |format|
      format.js
    end
  end

  # def alterplantype
  #   @user = User.find(params[:userId])
  #   company = @user.fetchCompany
  #   @plan = company.subscription.plan_per_user_range.plan
  #   respond_to do |format|
  #     format.js
  #   end
  # end

  def saveplantype
    user = User.find(params[:userId])
    plan = Plan.find(params[:planId]) 
    if user.subscription.present?
      plnperuser = PlanPerUserRange.where(:plan_id=>plan.id).last
      logger.debug(plnperuser.id)
      user.subscription.update_attributes(:plan_per_user_range_id=>plnperuser.id)
    end
    msg = {"plan"=> plan.name}
    render json:msg
  end

  def usercreatepopup
    @companies = User.where(:role_id=>2)
    respond_to do |format|
      format.js
    end
  end

  def cmpycreatepopup
    respond_to do |format|
      format.js
    end
  end

  def createUser
    @error = ''
    userAdmin = User.find(params[:company])
    if userAdmin.checkUserLimit 
      @user = User.new(:email=>params[:email], :name=>params[:name], :password=>"user.leadpump123")
      @user.reset_status = true
      @user.role_id = Role.find_by_role_type("employee").id
      if @user.save
        @user = Company.createUser(userAdmin, @user)
        @empcount = User.where(:role_id=>3).count
      else
        @error = @user.errors.full_messages.to_sentence
      end
    else
      @error = "Under this company no more user can be added."
    end
    respond_to do |format|
      format.js
    end
  end

  def createCmpy
    @error = ''
    @user = User.new(:email => params[:cmpyemail], :name => params[:cmpyname], :password => "company.leadpump123")
    @user.reset_status = true
    @user.role_id = Role.find_by_role_type("company").id
    @user.subscription = Subscription.new(:plan_per_user_range_id => 20, :expiry_date => Date.today+45.days, :users_count => 100, :locations_count => 100, :plan_type => "monthly")
    @cmpycnt = User.where(:role_id => 2).count
    if @user.save
      @user.send_reset_password_instructions
    else
      @error = @user.errors.full_messages.to_sentence
    end
    respond_to do |format|
      format.js
    end
  end

end
