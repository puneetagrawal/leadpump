class PictureController < ApplicationController
  

  def create
  	@picture_exist = Picture.find_by_user_id(current_user.id)
    begin 
  	if !@picture_exist.present?
  		@picture = Picture.create(:avatar=>params[:picture][:avatar],:user_id=>current_user.id)
  	else
  		@picture_exist.update_attributes(:avatar=>params[:picture][:avatar])
  	end
  rescue Exception => e
    flash[:error] = "Please try again"
  end
  	redirect_to settings_path
  end

  def show
  end

  
end
