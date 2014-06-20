class ApplicationController < ActionController::Base
  before_filter :authenticate_user!, :set_cache_buster
  protect_from_forgery



  # def set_locale

  #  @language = (params[:language].blank?) ? I18n.default_locale : params[:language]
  #  session[:locale] = @language  
  #  # session[:locale] = params[:locale]   if params[:locale]
  #  I18n.locale = session[:locale] || I18n.default_locale
  # end

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