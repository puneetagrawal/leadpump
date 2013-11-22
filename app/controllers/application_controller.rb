class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  protect_from_forgery

  #   def after_sign_in_path_for(resource)
  #     if current_user.role_id.eql?"1"
  # 	  admin_index_path
  # 	 else
  # 		root_url
  # 	 end
  # end

 
end