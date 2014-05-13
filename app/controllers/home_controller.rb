class HomeController < ApplicationController
  require 'httparty'
  include ApplicationHelper
  include HomeHelper
  skip_before_filter :authenticate_user!, :only => [:thanks, :pass, :print_pass, :storepassinsession,:calculateAmount, :terms, :create_new_user,
                                                     :signup_user, :send_verification_mail,
                                                     :confirmation, :save_password, :save_address,
                                                   :make_payment,:choose_plan,:skip_profile,
                                                    :contact_form, :test, :intouch]

  layout 'company_layout', only: [:pass, :print_pass]
  layout 'index_layout', only: [:signup_user]

  def index
    if current_user && !current_user.isAdmin
      @users = current_user.fetchCompanySalesUsers
      @users = @users.size == 1 ? @users.uniq : @users
      @users = @users.reverse
      @leads = Lead.fetchTotalLeads(current_user)
      #saletodate = SaleProd.fetchProdDataTotal(current_user)
      saletodate = SaleProd.fetchProdDataUpTotal(current_user, Date.today)
      @gross_values = SaleProd.fetchGrossMap(saletodate)
      @upgrade_user = upgrade_user(current_user)
      date = Date.today
      @newsfeeds = NewsFeed.get_today_news(current_user, date)
      @backlogs = NewsFeed.get_backlogs(current_user, date)
      @picture = Picture.new()
    elsif current_user && current_user.isAdmin
      redirect_to admin_index_path
    end
  end

  def testsendgrid
    response = HTTParty.get('https://api.sendgrid.com/api/stats.get.json?api_user=leadpump&api_key=4trading&days=2&category=socailReferring')
    response = response.gsub("[", " ")
    response = response.gsub("]", " ")
    response = response.gsub("{", " ")
    response = response.gsub("}", " ")
    response = response.split(",")[13]
    response = response.split(":")[1]
  end

  def terms
  end

  def test
    #AutoResponderRecord.send_auto_respond_mail
  end

  def privacy
  end

  def sendmail
    Emailer.sendtestmail().deliver
  end

  def fetchhotmailfriends
    @contacts = params[:email_list]
    respond_to do |format|
      format.js
    end
  end

  def fetchfbfreinds
    session[:email_user] = params[:user_email]
    @fbfreinds = params[:info]
    @fbfreinds = @fbfreinds.sort_by { |hsh| hsh[1]["name"] }
    respond_to do |format|
      format.js
    end
  end


  def welcome
  end

def calculateAmount
    @msg = User.signUpAmount(params[:plan_per_user_range], params[:du], params[:dp])
    respond_to do |format|
      format.json { render json: @msg }
    end
  end

  def fillpopupcontent
    @home = params[:uri]
    if params[:act] == 'leadpopup'
      @lead = Lead.find(params[:id])
    elsif params[:act] == 'userpopup'
      @user = User.find(params[:id])
    end
    if @home == 'cal'
      @task_hash = Lead.fetchAppointmentData(@lead.id)
      logger.debug @task_hash
    end
    respond_to do |format|
      format.js
    end
  end

  def changestatus
    if ((params[:urls].include? 'company') || (params[:urls].include? 'admin'))
      @user = User.find(params[:leadId])
    else
      @lead = Lead.find(params[:leadId])
    end
    respond_to do |format|
      format.js
    end
  end

  def saveleadstatus
    if ((params[:urls].include? 'company') || (params[:urls].include? 'admin'))
      object = User.find(params[:leadId])
      object.active = params[:status] == "false" ? false : true
      status = Lead.checkLeadStatus(object.active)
    else
      object = Lead.find(params[:leadId])
      object.status = params[:status]
      status = params[:status]
    end
    object.save

    msg = {"status"=>status}
    render json :msg
  end

  def deleteRowByajax
    if ((params[:uri].include? 'company') || (params[:uri].include? 'admin'))
      object = User.find(params[:leadId])
      userss = []
      company = []
      company << object
      Lead.assigndeletedleadtocompany(object)
      Appointment.assigndeletedappointmenttocompany(object)
      OptInLead.assignOptinToAdmin(object)
      if object.isCompany
        company = User.fetchCompanyUserList(object)
      end
      if company.present?
        company.each do |user|
          cmp = Company.where(:company_user_id=>user).last
          cmp.destroy
          user.destroy
        end
      end
    else
      object = Lead.find(params[:leadId])
      if object.present?
        userleads = UserLeads.where(:lead_id=>object.id)
        userleads.each do |userlead|
          userlead.destroy
        end
      end
    end
    if object.destroy
      msg = {"msg"=>"successfull"}
    else
      msg = {"msg"=>"successfull"}
    end
#msg = {"msg"=>"successfull"}
    respond_to do |format|
      format.json { render json: msg }
    end
  end

  def contacts_callback
    unless request.env['omnicontacts.contacts'].blank?
      @contacts = request.env['omnicontacts.contacts']
    end
  end

  def send_invitation_social
    message="Please join Leadpump "
    email_id=params[:check_invite_email]
    mail_invitaion(message, email_id)
    redirect_to "/"
  end

  def pass
    @user = User.find(params[:id])
    Company.removeAllPrintPassSessions(session)
    @company = @user.fetchCompany
    landpage = LandingPage.where(:user_id=>@company.id).last
    @dayscount = landpage.present? ? landpage.no_of_days.present? ? landpage.no_of_days : 1 : 1
  end

  def print_pass
    @temp = TemporaryData.first
    @dayscount = params[:dy].present? ? params[:dy] : 10
    @down = "true"
    date = Date.today + @dayscount.to_i
    @user = User.find(params[:user])
    @company = @user.fetchCompany
    NewsFeed.create(:user_id=>@user.id, :lead_id=>params[:lead], :description=>"Guest Pass Expiring", :feed_date=>date, :action=>"Start")
    @pf = WickedPdf.new.pdf_from_string(render_to_string('home/_printPass.html.erb', :layout=>false))
    respond_to do |format|
      format.pdf do
        send_data @pf, filename: "pass.pdf", type: 'application/pdf', disposition: 'inline'
      end
    end
    #  respond_to do |format|
    #   format.js do
    #     send_data filename: "foo.pdf",
    #               type: "application/pdf",
    #               disposition: "attachment"
    #   end
    # end
  end

  def storepassinsession
    TemporaryData.first.update_attributes(params[:fn].to_sym => params[:val])
    msg = {"success"=>"dd"}
    TemporaryData.first.prg
    respond_to do |format|
      format.json { render json: msg }
    end
  end

  def upgrade_plan
    @planPerUser = PlanPerUserRange.find(params[:planPerUser])
  end

  # def make_payment
  #   logger.debug(params)
  #   @planPerUser = PlanPerUserRange.find(params[:planPerUserId])
  #   planType = params[:planType] == '2' ? 'yearly' : 'monthly'
  #   amt = User.signUpAmount(params[:planPerUserId], params[:discountOnUsers], planType)
  #   total_amount = amt["amount"].to_i * 100
  #   company = current_user.fetchCompany
  #   email = company.email
  #   stripe_token = params["user_subscription_attributes_stripe_card_token"]
  #   begin
  #     if company.subscription.customer_id.present?
  #       customer_id = company.subscription.customer_id
  #       # charge = Stripe::Charge.create(
  #       # :amount => total_amount, # in cents
  #       # :currency => "usd",
  #       # :customer => customer.id
  #       # )
  #     else
  #       customer = Stripe::Customer.create(
  #           :email => email,
  #           :description => "Subscribed for #{@planPerUser.plan.name} plan.",
  #           :card => stripe_token
  #       )
  #       # charge = Stripe::Charge.create(
  #       # :amount => total_amount, # in cents
  #       # :currency => "usd",
  #       # :customer => customer.id
  #       # )
  #       customer_id = customer.id
  #     end
  #     date = planType == "monthly" ? Date.today + 45 : Date.today + 380
  #     Subscription.saveSubscription(company, @planPerUser.id, stripe_token, date, amt["amount"].to_i, params[:discountOnUsers], params[:no_of_locations], planType, customer_id, "")
  #     flash[:notice] = "Plan upgraded successfully"
  #     redirect_to dashboard_path()
  #   rescue Stripe::CardError => e
  #     body = e.json_body
  #     err = body[:error]
  #     @cardError = "#{err[:message]}"
  #     render :action => "upgrade_plan"
  #     return false
  #   rescue Stripe::InvalidRequestError => e
  #     @cardError = "Invalid parameters were supplied to Stripe API"
  #     render :action => "upgrade_plan"
  #     return false
  #   rescue Stripe::AuthenticationError => e
  #     @cardError = "Authentication with Stripe's API failed"
  #     render :action => "upgrade_plan"
  #     return false
  #   rescue Stripe::APIConnectionError => e
  #     @cardError = "Network communication with Stripe failed"
  #     render :action => "upgrade_plan"
  #     return false
  #   rescue Stripe::StripeError => e
  #     @cardError = "Display a very generic error to the user, and maybe send yourself an email"
  #     render :action => "upgrade_plan"
  #     return false
  #   rescue => e
  #     @cardError = "Something bad happened, Please try again"
  #     render :action => "upgrade_plan"
  #     return false
  #   end
  # end

  def fetch_upgrade_plan
    plan = current_user.subscription.plan_per_user_range
    @all_plan = PlanPerUserRange.order("id ASC").where("user_range_id = ? and plan_id != ?", plan.user_range_id, plan.plan_id)
    respond_to do |format|
      format.js
    end
  end

  def plan_upg_mail
    begin
      company = current_user.fetchCompany
      email = company.email_list
      name = current_user.name
      user_email = current_user.email
      Emailer.send_upgrade_mail(email, name, user_email).deliver
    rescue Exception => e
    end
    @msg = {:msg=>"sent successfully"}
    respond_to do |format|
      format.json { render json: @msg }
    end
  end

  def plan_cancel
    current_user.has_cancelled = true
    users = User.fetchCompanyUserList(current_user)
    if users.present?
      users.each do |user|
        user.original_email = current_user.email
        user.email = "cXz#{user.email}zXc"
        user.save
      end
    end
    current_user.original_email = current_user.email
    current_user.email = "cXz#{current_user.email}zXc"
    current_user.save
    @msg = {:msg=>"sent successfully"}
    respond_to do |format|
      format.json { render json: @msg }
    end
  end

  def thanks
    sign_out current_user
  end

  def signup_user
    @user = params[:user].present? ? User.find_by_token(params[:user]) : nil
  end

  def create_new_user
    @user = User.new(:role_id=>2,:verified=>false,:password=> "xszleadxsz", :email=>params[:email], :name=>params[:name], :lname=>params[:last_name])
    if @user.valid?
      @user.save
    else
    end
    @cls = params[:cls]
    respond_to do |format|
      format.js
    end
  end

  def send_verification_mail
    user = User.find_by_email(params[:email])
    @msg = "Please try again."
    if user.present? && !user.verified
        Emailer.send_verification_mail(user).deliver
        @msg = create_verify_text
    end
    message = {"msg"=> @msg}
    render json: message
  end

  def confirmation
    if params[:confirmation_token].present?
      @user = User.find_by_token(params[:confirmation_token])
      @msg = "Your token is exprired"
      if @user.present? && !@user.verified
        @msg = "You have been successfully verified"
        redirect_to new_plan_path(:user=>@user.token)
      else
        redirect_to dashboard_path
      end
    else
      redirect_to dashboard_path
    end
  end

  def skip_profile
    current_user.verified = true
    current_user.save
    @name = params[:id]
    @picture = Picture.new()
    respond_to do |format|
      format.js
    end
  end

  def choose_plan
    @user = User.find(params[:user])
    @add = Address.find_by_user_id("#{@user.id}")
    @planPerUser = PlanPerUserRange.find(params[:plan_range])
    @cardError = params[:card_eror].present? ? params[:card_eror] : ''
    respond_to do |format|
      format.js
    end
  end

  def save_password
    user = User.find(params[:user])
    if user.present?
      user.password = params[:password]
      user.save
    end
    render json: {"msg"=> "success"}
  end

  def save_address
    @user = User.find(params[:user])
    @add = Address.where(:user_id=>"#{@user.id}").last
    if @add.present?
      @add.update_attributes(params[:address])
      @add.user_id = "#{@user.id}"
      @add.save
    else
      @add = Address.new(params[:address])
      @add.user_id = "#{@user.id}"
      if @add.save
      else
        logger.debug(@add.errors.full_messages)
      end
    end
    @user.company_name = params[:company_name]
    @user.save
    respond_to do |format|
      format.js
    end
  end

  def make_payment
    planPerUser = PlanPerUserRange.find(params[:planPerUserId])
    @user = User.find(params[:user])
    @cardError = ''
    if @user.present?
      logger.debug("user found")
      planType = params[:planType] == '2' ? 'yearly' : 'monthly'
      amt = User.signUpAmount(planPerUser.id, params[:discountOnUsers], planType)
      total_amount = amt["amount"].to_i * 100
      begin
        email = @user.email.to_s
        logger.debug("inside begin")
        logger.debug(email)
        customer = Stripe::Customer.create(
          :email => email,
          :description => "Subscribed for #{planPerUser.plan.name} plan.",
          :card  => params["stripe_card_token"]
          )
        # charge = Stripe::Charge.create(
        #       :amount => total_amount, # in cents
        #       :currency => "usd",
        #       :customer => customer.id
        # )
        logger.debug("user saving")
        if @user.save
          logger.debug("after saved")
         date = planType == "monthly" ? Date.today + 45 : Date.today + 380
         Subscription.saveSubscription(@user, planPerUser.id, params["stripe_card_token"], date, amt["amount"].to_i, params[:discountOnUsers], params[:no_of_locations], planType, customer.id, "")
        logger.debug("subscription saving")
         address = Address.find_by_user_id("#{@user.id}")
         logger.debug("address found")
         Emailer.send_user_info_to_admin(@user, params[:user_ip], address).deliver
         logger.debug("email sended")
         sign_in :user, @user
        end
      rescue Stripe::CardError => e
        body = e.json_body
        err  = body[:error]
        @cardError = "#{err[:message]}"
      rescue Stripe::InvalidRequestError => e
        @cardError = "Invalid parameters were supplied to Stripe API"
      rescue Stripe::AuthenticationError => e
        @cardError = "Authentication with Stripe's API failed"
      rescue Stripe::APIConnectionError => e
        @cardError = "Network communication with Stripe failed"
      rescue Stripe::StripeError => e
        @cardError = "Display a very generic error to the user, and maybe send yourself an email"
      rescue => e
        @cardError = "Something bad happened, Please try again"
      end
      logger.debug(@cardError)
      logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
    end
    if @cardError != ''
        redirect_to new_plan_path(:user=>@user.token,:card_error=>@cardError,:plan_per_user_range=>params[:planPerUserId])
    else
      redirect_to dashboard_path
    end
  end

  def upload_company_logo
    @picture = Picture.new()
    current_user.verified = true
    if !current_user.picture.present?
      Picture.create(:company_logo=> params[:picture][:company_logo],:user_id=>current_user.id)
    else
      current_user.picture.company_logo = params[:picture][:company_logo]
      if current_user.picture.save
      else
      end
    end
    current_user.save
    respond_to do |format|
      format.js
    end
  end

  def upload_profile_pic
    @picture = Picture.new()
    if !current_user.picture.present?
      Picture.create(:avatar=> params[:picture][:company_logo],:user_id=>current_user.id)
    else
      current_user.picture.avatar = params[:picture][:company_logo]
      if current_user.picture.save
      else
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def save_refs
    if params[:id] == "0"
      current_user.vipon = false
    else
      current_user.vipcount = !params[:ref].blank? ? params[:ref] : 3
      current_user.vipon = true
    end
      current_user.save
      render json: {"msg"=> "success"}
  end

  def contact_form
    Emailer.send_contact_form(params[:contact_email], params[:contact_name], params[:contact_subject],params[:contact_message]).deliver
    respond_to do |format|
      format.js
    end
  end

  private

  def mail_invitaion(message, email_id)
    unless email_id.blank?
      email_id.each do |email|
        begin
          Emailer.invite_friends(message, email).deliver
        rescue Exception => e
        end
      end
    end
  end

end
