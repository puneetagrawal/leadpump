class PictureController < ApplicationController
  

  def create
    user = params[:u_id].present? ? User.find(params[:u_id]) : current_user
    logger.debug("DFDDDDDDDDDDDDDD")
    logger.debug(user.id)
  	@picture_exist = Picture.find_by_user_id(user.id)
    logger.debug(params[:picture][:avatar])
    begin 
  	if !@picture_exist.present?
      logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>")
  		@picture = Picture.create(:avatar=>params[:picture][:avatar],:user_id=>user.id)
  	else
      logger.debug("dsfeldlseleeeeeeeeeeeee")
  		@picture_exist.update_attributes(:avatar=>params[:picture][:avatar])
  	end
  rescue Exception => e
    flash[:error] = "Please try again"
  end
    if params[:home_dash].present?
      redirect_to home_index_path()
    elsif params[:u_id].present?
      redirect_to company_new_path()
    else
    	redirect_to settings_path
    end
  end

def createvippic
    @picture_exist = Picture.find_by_user_id(current_user.id)
    begin 
    if !@picture_exist.present?
      @picture = Picture.create(:viplogo=>params[:picture][:viplogo],:user_id=>current_user.id)
    else
      @picture_exist.update_attributes(:viplogo=>params[:picture][:viplogo])
    end
    rescue Exception => e
      flash[:error] = "Please try again"
    end
    redirect_to settings_path
  end

  def show
  end

  
end
