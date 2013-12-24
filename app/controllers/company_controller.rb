class CompanyController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:calculateAmount, :terms, :welcome]
  layout 'reflanding', only: [:preview]

  def index
    companyUsers = Company.where(:company_admin_id => current_user.id)
    companyUsers = companyUsers.pluck(:company_user_id)
    @users = companyUsers   
  end

  def show
  end

  def new
  	@user = User.new()
    @users = User.fetchCompanyUserList(current_user)
  end

  def create
    if current_user.checkUserLimit
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
      @users = User.fetchCompanyUserList(current_user)
      render :action =>"new"
    end
  end

  def edit
    @user = User.find(params[:id])  
    respond_to do |format|
        format.js 
    end 
  end

  def update
    @userUpdate = User.find(params[:id]) 
    if @userUpdate.update_attributes(params["inputs"]["user"])
      @user = User.new
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
    saletodate = SaleProd.fetchProdDataUpToDate(@user, Date.today)
    @gross_values = SaleProd.fetchGrossMap(saletodate)
    @project = "true"
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
    redirect_to home_index_path
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
  if current_user.isCompany
    @picture_user = Picture.fetchCompanyLogo(current_user.id)
    @picture = Picture.new
  else
    redirect_to home_index_path
  end
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
    redirect_to home_index_path
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
    redirect_to home_index_path
  end
end

def refland
end

def previewsave
  Preview.destroy_all
  params[:inputs][:landing_page].delete :land_type
  temp_name = params[:inputs][:landing_page][:temp_name]
  params[:inputs][:landing_page].delete :temp_name
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

end
