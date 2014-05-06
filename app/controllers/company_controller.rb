class CompanyController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:calculateAmount, :terms, :welcome, :unsubscribe]
  layout 'reflanding', only: [:preview]

  def index
    companyUsers = Company.where(:company_admin_id => current_user.id)
    companyUsers = companyUsers.pluck(:company_user_id)
    @users = companyUsers   
  end

  def show
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
      if @user.save      
        Company.createUser(current_user, @user)
        flash[:success] = "User successfully created"
        redirect_to company_new_path()      
      else
        @users = User.fetchCompanyUserList(current_user)
        render :action =>"new"
      end
    else
      flash[:alert] = "Sorry! your user creation limit exceeded."
      @user = User.new()
      @picture = Picture.new()
      @users = User.fetchCompanyUserList(current_user)
      render :action =>"new"
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
      redirect_to '/autoresponder'
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
  # def report
  #     user_ary = []
  #     Company.report()
      
  # end

  def social_message_page
    logger.debug("<<<<<<<<<<<<<<<<<<<<")
    logger.debug(params[:name])
    @landpage = LandingPage.find_by_user_id(current_user.id)
    if !@landpage.present?
      @landpage = LandingPage.new
    end
    @company = current_user.fetchCompany
    @auto_responder = AutoResponder.where(:user_id=>current_user).order('id asc')
    @auto_res = AutoResponder.new

    @onlinemall = Onlinemall.new
    if current_user.isAdmin
      @onlinemalls = Onlinemall.includes(:mallpic).includes(:user).order("created_at DESC")
    elsif current_user.isCompany
      logger.debug(">>>>>>>>")
      @onlinemalls = Onlinemall.includes(:mallpic).includes(:user).order("created_at DESC").where(:user_id=>[current_user,1])
    end
    
    @temp_name = params[:name]
    respond_to do |format|
      format.js 
    end
  end
  
  


end

