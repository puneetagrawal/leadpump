class CompanyController < ApplicationController
  before_filter :authenticate_user!

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
    
      @user = User.new(params[:user])
      @user.password = "user.leadpump123"
      @user.role_id = Role.find_by_role_type("employee").id
      if @user.save      
        company = Company.new(:company_admin_id => current_user.id, :company_user_id => @user.id)
        company.save
        current_user.update_attributes(:users_created=> current_user.users_created+1)
        begin 
          @user.send_reset_password_instructions
        rescue Exception => e
        end
        flash[:success] = "User successfully created"
        redirect_to company_new_path()      
      else
        @users = User.fetchCompanyUserList(current_user)
        render :action =>"new"
      end
    # else
    #   flash[:alert] = "Sorry! your user creation limit exceeded."
    #   @user = User.new()
    #   @users = User.fetchCompanyUserList(current_user)
    #   render :action =>"new"
    # end
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
    SocialMessage.create(:facebookMessage=>params[:text], :company_id=>current_user.id)
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
    SocialMessage.create(:gmailMessage=>params[:text], :company_id=>current_user.id)
  end
  render json: message
end

def settings
  @picture_user = Picture.fetchCompanyLogo(current_user.id)
   @picture = Picture.new
end

end
