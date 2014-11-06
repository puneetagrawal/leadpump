class ApplicationController < ActionController::Base
  before_filter :authenticate_user!, :set_cache_buster, :cors_preflight_check
  after_filter :cors_set_access_control_headers
  
  protect_from_forgery

    def after_sign_in_path_for(user)
      url = dashboard_path
      case user.user_role.role_type.to_sym  
      when :admin
        url = admin_index_path    
      end
  	 return url
  end


  

# For all responses in this controller, return the CORS access control headers.

  def cors_set_access_control_headers
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Max-Age'] = "1728000"
    end

    # If this is a preflight OPTIONS request, then short-circuit the
    # request, return only the necessary headers and return an empty
    # text/plain.

    def cors_preflight_check
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
      headers['Access-Control-Max-Age'] = '1728000'
    end
    
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
  
end