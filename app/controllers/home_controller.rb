class HomeController < ApplicationController

def index
	@user = User.new
end

def test
	puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
	puts params
	@user = User.new(params[:user])
    if @user.save
      flash[:success] = "Welcome to the Sample App!"      
    else
      flash[:success] = "Welcomdfsdfsdfsfsfdfsfd"      
    end  
end

end
