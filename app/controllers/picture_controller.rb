class PictureController < ApplicationController
  def create
  	@picture = Picture.create(:avtar=>params[:picture][:avtar],:user_id=>current_user.id)
  end

  def show
  end
end
