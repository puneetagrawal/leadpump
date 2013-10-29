class EmployeeController < ApplicationController
  	before_filter :authenticate_user!
def index
    @users = User.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  def new
  	@user = User.new(params[:user])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
        redirect_to employee_index_path()
    else
        render :action => "new"
    end
  end

  def update
  end

  def delete
  end
end
