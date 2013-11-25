class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  protect_from_forgery

    def after_sign_in_path_for(user)
      url = root_url
      case user.user_role.role_type.to_sym  
      when :admin
        url = admin_index_path    
      end
  	 return url
  end
  
end