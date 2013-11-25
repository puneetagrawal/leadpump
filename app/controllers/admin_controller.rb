class AdminController < ApplicationController
require 'will_paginate/array'

def index
end

def user
 @users = User.all.paginate(:page => params[:page], :per_page => 10)
end

def plan

end

def statistic
@vipleads = VipLead.all
end

def payment
 @users = User.all
end

def user_record
	@users = User.all.paginate(:page => params[:page], :per_page => params[:search_val])
end

end
