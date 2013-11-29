class StatssController < ApplicationController
  
  def index
  	@stats = Stats.where(:user_id=>current_user.id)
  end
end
