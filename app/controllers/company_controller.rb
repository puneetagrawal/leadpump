class CompanyController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:calculateAmount, :terms, :welcome, :unsubscribe, :save_external_lead]
  before_filter :set_access_control_headers
            
  layout 'reflanding', only: [:preview]

  def index
    companyUsers = Company.where(:company_admin_id => current_user.id)
    companyUsers = companyUsers.pluck(:company_user_id)
    @users = companyUsers   
  end

  def show
  end

  respond_to :json
  def save_external_lead
    user = User.where(:token=>params[:token]).last
    lead = Lead.new(name: params[:name], lname: params[:lname],email: params[:email], phone: params[:phone], lead_source: params[:lead_source])
    if !user.present?
      message = "Please Enter Valid Fiels"
    elsif lead.save
      user_lead = UserLeads.new(:user_id => user.id, :lead_id => lead.id)
      user_lead.save
      NewsFeed.create(:user_id=>user.id, :lead_id=>lead.id, :description=>"New External Entry Lead", :feed_date=>Date.today, :action=>"Start")
      message = "Thanks For registration"
    else
      message = lead.errors.full_messages[0].humanize
    end
    render :json => message.to_json, :callback => params['callback']
    # respond_with message
    # respond_to do |format|
    #   msg = {message: message}
    #   format.json { render json: {message: "dfdfdf"}}
    # end
  end

  def create_code_image
    img = HtmlCodeImage.where(:user_id=> current_user.id).last
    if img.present?
      img.avatar = params[:html_code_image][:avatar]
      img.save
    else
      img = HtmlCodeImage.new(:avatar=> params[:html_code_image][:avatar],
       :user_id=> current_user.id)
      img.save
    end
    @url = "http://#{SERVER_URL}#{img.avatar.url(:medium)}"
    respond_to do |format|
      format.js
    end
  end

  def new
    @company = false
  	@user = User.new()
    @picture = Picture.new()
    @users = User.fetchCompanyUserList(current_user)
    @users.insert(0, current_user)
  end

  def create
    if current_user.checkUserLimit
      @company = false
      @user = User.new(params[:user])
      @user.password = "user.leadpump123"
      @user.reset_status = true
      @user.role_id = Role.find_by_role_type("employee").id
      # @user.verified = true
      @picture = Picture.new()
      if @user.save      
        Company.createUser(current_user, @user)
        flash[:success] = "User successfully created"
        redirect_to settings_path      
      else
        @users = User.fetchCompanyUserList(current_user)
        render :action =>"settings"
      end
    else
      flash[:alert] = "Sorry! your user creation limit exceeded."
      @user = User.new()
      @picture = Picture.new()
      @users = User.fetchCompanyUserList(current_user)
      render :action =>"settings"
    end
  end

  def edit
    @user = User.find(params[:id])  
    @company = false
    if @user.isCompany
      @company = true
      @address = Address.where(:user_id=>"#{@user.id}").last
    end
    respond_to do |format|
        format.js 
    end 
  end

  def update
    @userUpdate = User.find(params[:id]) 
    @picture = Picture.new()
    if @userUpdate.update_attributes(params["inputs"]["user"])
      @user = User.new
      if @userUpdate.isCompany
        address = Address.where(:user_id=>params[:id]).last
        if address.present?
          address.address = params[:inputs][:address]
          address.phone = params[:inputs][:phone]
          address.zip = params[:inputs][:zip]
          address.city = params[:inputs][:city]
          address.state = params[:inputs][:state]
          address.country = params[:inputs][:country]
          address.save
        else
          Address.create(:address=>params[:inputs][:address],:phone=>params[:phone],
            :zip=>params[:inputs][:zip],:city=>params[:inputs][:city],:state=>params[:inputs][:state],
            :country=>params[:inputs][:country],:user_id=>params[:id])
        end
      end
    else
    end
    respond_to do |format|
        format.js 
    end
  end

  def delete
    user = User.find(params[:id]) 
    company = Company.find_by_company_user_id(user.id)
    if user.delete
      company.delete
      flash[:success] = "User successfully deleted"
      redirect_to company_index_path()
    else
      flash[:alert] = "please try again"
      redirect_to company_index_path()
    end
  end

  def viewusergauge
    @user = User.find(params[:id])
    @leads = Lead.fetchTotalLeads(@user)
    saletodate = SaleProd.fetchProdDataUpTotal(@user, Date.today)
    @gross_values = SaleProd.fetchGrossMap(saletodate)
    respond_to do |format|
      format.js 
    end
  end

  def changeuserstatus
    @user = User.find(params[:userId])  
    #@status = @lead.active ? "Active" : "Inactive"
    respond_to do |format|
      format.js 
    end
  end

  def getemails
    if params[:term]
     like  = "%".concat(params[:term].concat("%"))
     users = User.where("email like ?", like)
   else
    users = User.all
    end
    list = users.map {|l| Hash[id: l.id, label: l.email, name: l.email]}
    render json: list
  end

  def usersearchfilter
    @users = User.find(params[:id])
    respond_to do |format|
      format.js 
    end
  end

  def socialMessages
    if current_user.isEmployee || current_user.isNormaluser
      flash[:notice] = "Sorry! you are not authorize user to perform this action."
      redirect_to dashboard_path
      return false
    end
  end

  def savetwmes
    company = current_user.fetchCompany
    socailMessage = SocialMessage.find_by_company_id(company.id)
    if params[:text].blank?
      message = {"msg"=>"Please Enter some text."}
    elsif socailMessage.present?
      socailMessage.update_attributes(:twitterMessage=>params[:text])
      message = {"msg"=>"Message saved successfully"}
    else
      SocialMessage.create(:twitterMessage=>params[:text], :company_id=>current_user.id)
    end
    render json: message
  end

  def savefbmes
    company = current_user.fetchCompany
    socailMessage = SocialMessage.find_by_company_id(company.id)
    if params[:text].blank?
      message = {"msg"=>"Please Enter some text."}
    elsif socailMessage.present?
      socailMessage.update_attributes(:facebookMessage=>params[:text],:fbsubject=>params[:subject])
      message = {"msg"=>"Message saved successfully"}
    else
      SocialMessage.create(:facebookMessage=>params[:text],:fbsubject=>params[:subject], :company_id=>current_user.id)
    end
    render json: message
  end

  def savegmmes
    company = current_user.fetchCompany
    socailMessage = SocialMessage.find_by_company_id(company.id)
    if params[:text].blank?
      message = {"msg"=>"Please Enter some text."}
    elsif socailMessage.present?
      socailMessage.update_attributes(:gmailMessage=>params[:text],:gmailsubject=>params[:subject])
      message = {"msg"=>"Message saved successfully"}
    else
      SocialMessage.create(:gmailMessage=>params[:text],:gmailsubject=>params[:subject], :company_id=>current_user.id)
    end
    render json: message
  end

  def settings
      @picture = Picture.new
  end

  def savevipsetings
    if !params[:vipon].blank?
       current_user.update_attributes(:vipon=>true, :vipcount=>params[:vipvalue].to_i)
    else
       current_user.update_attributes(:vipon=>false)
    end
    render json: {"msg"=>""}
  end

  def landpage
    if current_user.isCompany
      @landpage = LandingPage.find_by_user_id(current_user.id)
      if !@landpage.present?
        @landpage = LandingPage.new
      end
    else
      flash[:notice] = "You are not authorie for this action"
      redirect_to dashboard_path
    end
  end

  def createlanding
    logo = Company.fetchlogofromparam(params)
    if params[:landing_page][:land_type] == "External landing page"
      landingpage = LandingPage.new(:land_type=>"External landing page",:ext_link=>params[:landing_page][:ext_link])
    else
      landingpage = LandingPage.new(params[:landing_page])
    end
    landingpage.user_id = current_user.id
    if landingpage.save
      flash[:notice] = "Land page created"
      Company.savelandpagelogo(landingpage, logo)
      redirect_to settings_path
    else
      redirect_to landpage_path
    end
  end

  def updatelanding
    logo = Company.fetchlogofromparam(params)
      if current_user.isCompany
      @landpage = LandingPage.find(params[:id])
      if @landpage.present?
        if params[:landing_page][:land_type] == "External landing page"
          @landpage.update_attributes(:land_type=>"External landing page",:ext_link=>params[:landing_page][:ext_link])
        else
          @landpage.update_attributes(:ext_link=>'',:temp_name=>params[:landing_page][:temp_name],:land_type=>"Internal landing page",
            :intro_text=>params[:landing_page][:intro_text], :header_text=>params[:landing_page][:header_text],
            :mission_text=>params[:landing_page][:mission_text], :header_color=>params[:landing_page][:header_color],
            :bg_color=>params[:landing_page][:bg_color], :no_of_days=>params[:landing_page][:no_of_days])
        end
        Company.savelandpagelogo(@landpage, logo)
        flash[:success] = "LandPage updated successfully"
        redirect_to settings_path
      end
    else
      flash[:notice] = "You are not authorie for this action"
      redirect_to dashboard_path
    end
  end

  def refland
  end

  def previewsave
    Preview.destroy_all
    params[:inputs][:landing_page].delete :land_type
    temp_name = params[:inputs][:landing_page][:temp_name]
    #params[:inputs][:landing_page].delete :temp_name
    params[:inputs][:landing_page].delete :ext_link
    landpage = Preview.new(params[:inputs][:landing_page])
    landpage.save
    temp = "2"
    if temp_name == "Guest pass card"
      temp = "1"
    end
    message = {"temp"=>temp}
    render json: message
  end

  def preview
    @landpage = Preview.last
    @preview = true
    if params[:id].present? && params[:id] == "1"
      @temp = true
    else
      @temp = false
    end
  end

  def autoresponder
    @company = current_user.fetchCompany
    @auto_responder = AutoResponder.where(:user_id=>current_user).order('id asc')
    @auto_res = AutoResponder.new
  end

  def create_auto_responder
    from_email = params[:from_email]
    if params[:ar_id].present?
      ar_id = params[:ar_id].split(" ")
      ar_id.each do|upd|
        if !params["res_#{upd}"].blank?
          respond = AutoResponder.find(upd)
          current_user.from_email = from_email
          if current_user.save
          else
             (respond.errors.full_messages)
          end
          respond.update_attributes(params["res_#{upd}"])
        end
      end
    else
    (1..10).each do |vip| 
        if !params["res_#{vip}"].blank?
          respond = AutoResponder.new(params["res_#{vip}"])
          if respond.valid?
            AutoResponder.saveResponder(respond,current_user,from_email)
          else
            respond.errors.full_messages
          end
        end
      end
    end
      redirect_to '/settings'
  end

  def unsubscribe
    lead = Lead.where(:lead_token=>params[:unsub]).last
    if lead.present? && lead.subscribe
      lead.subscribe = false
      lead.save
      @unsub_message = "You have been unsubscirbed successfully."
    else
      flash[:notice] = "You are trying to access invalid url."
      redirect_to "/"
    end
  end
  
  def social_message_page
    @temp_name = params[:name]
    if @temp_name == "manage_landing"
      @landpage = LandingPage.find_by_user_id(current_user.id)
      if !@landpage.present?
        @landpage = LandingPage.new
      end
    
    elsif @temp_name == "responder"
      @company = current_user.fetchCompany
      @auto_responder = AutoResponder.where(:user_id=>current_user).order('id asc')
      @auto_res = AutoResponder.new
    
    elsif @temp_name == "online_mall"
      @onlinemall = Onlinemall.new
      @user_selected_onlinemall = Companymallitem.where(user_id: current_user.id)
      if current_user.isAdmin
        @onlinemalls = Onlinemall.includes(:mallpic).includes(:user).order("created_at DESC")
      elsif current_user.isCompany
        @onlinemalls = Onlinemall.includes(:mallpic).includes(:user).order("created_at DESC").where(:user_id=>[current_user,1])
      end
    
    elsif @temp_name == "manage_user" || @temp_name == "dusr_set"
      @company = false
      @user = User.new()
      @picture = Picture.new()
      @users = User.fetchCompanyUserList(current_user)
      @users.insert(0, current_user)
    elsif @temp_name == "account_setting"
      @user = current_user
      @add = Address.find_by_user_id("#{current_user.id}")
      @add = @add.present? ? @add : Address.new
    elsif @temp_name == "code_gen"
      @lead = Lead.new
      @code_image = HtmlCodeImage.new
      @img = current_user.html_code_image
    end
    @picture = Picture.new()
    respond_to do |format|
      format.js 
    end
  end

  def save_dusr_report
    user = User.find(params[:user_id])
    if params[:dusr] == "true"
      user.dusr = true
    else
      user.dusr = false
    end
    user.save
    render json: {message: "success"}
  end

  def auto_responder_subscribe
    lead = Lead.find(params[:lead_id])
    if params[:subscribe] == "true"
      lead.subscribe = true
    else
      lead.subscribe = false
    end
    lead.save
    render json: {message: "success"}
  end

  def acc_setting_address
    @btn_name = params[:btn_name]
    if @btn_name == "addrs"
      @user = current_user
      @add = Address.find_by_user_id("#{current_user.id}")
      @add = @add.present? ? @add : Address.new
    end
    respond_to do |format|
      format.js 
    end
  end

  def save_acc_settings
    if params[:address].present?
      Address.save_user(params[:address], params[:company_name], current_user)
    elsif params[:stripe_card_token]
      email = current_user.email
      stripe_token = params[:stripe_card_token]
      begin
          email = current_user.email.to_s
          customer = Stripe::Customer.create(
            :email => email,
            :description => "Creating Card Info",
            :card  => params["stripe_card_token"]
            )
          if params[:discountOnUsers].present?
              Subscription.upgrade_user_plan(current_user, params[:plan_per_user_range_id],params[:discountOnUsers], params[:no_of_locations],
                 customer.id, params["stripe_card_token"])
          else
            CreditCard.create(:user_id=>current_user.id, :customer_id=>customer.id)
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
    end
    respond_to do |format|
      format.js 
    end
  end

  def upgrade_user_plan
  end

  def save_waiver_text
    @message = ""
    if params[:title] && params[:desc].present?
      desk_desc = FrontDeskDesc.find_by_user_id(current_user.id)
      if desk_desc.present?
        desk_desc.title = params[:title]
        desk_desc.description = params[:desc]
        desk_desc.save
      else
        front_desk = FrontDeskDesc.create(:title => params[:title], :description => params[:desc], :user_id => current_user.id)
      end
      @message = "Waiver text saved successfully"
    else
      @message = "Message not saved"      
    end
    respond_to do |format|
      format.js
    end    
  end

  def  set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = '*'
    headers['Access-Control-Allow-Credentials'] = "true"
  end

end

