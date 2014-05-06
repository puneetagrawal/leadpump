class ApplicationController < ActionController::Base
  before_filter :authenticate_user!, :set_cache_buster
  protect_from_forgery

    def after_sign_in_path_for(user)
      url = dashboard_path
      case user.user_role.role_type.to_sym  
      when :admin
        url = admin_index_path    
      end
  	 return url
  end

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  
end