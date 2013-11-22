class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  protect_from_forgery

    def after_sign_in_path_for(resource)
      if current_user.role_id == 1
  	  	url = admin_index_path
  	 else
  		url = root_url
  	 end
  	 return url
  end

 
end