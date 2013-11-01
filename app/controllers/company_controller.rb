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
  end

  def create
    @user = User.new(params[:user])
    @user.password = "user.leadpump123"
    @user.role_id = Role.find_by_role_type("company").id
    if @user.save      
      company = Company.new(:company_admin_id => current_user.id, :company_user_id => @user.id)
      company.save
      flash[:success] = "User successfully created"
      redirect_to company_index_path()
    else
        render "new"
    end
  end

  def edit
    @user = User.find(params[:id])   
  end

  def update
    user = User.find(params[:id]) 
    user.update_attributes(params[:user])
    flash[:success] = "User successfully updated"
    redirect_to company_index_path()
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

end
