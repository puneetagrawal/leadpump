class OnlinemallController < ApplicationController
  def index
    if current_user.isCompany || current_user.isAdmin
    	@onlinemalls = Onlinemall.all
    	@onlinemall = Onlinemall.new
    else
      redirect_to home_index_path
    end
  end

  def create
  	@onlinemall = Onlinemall.new(:title=>params[:onlinemall][:title], :link=>params[:onlinemall][:link],:user_id=>current_user.id)
  	mallpic = nil
  	if !params["onlinemall"]["mallpic_attributes"]["0"]["avatar"].blank?
  		mallpic = Mallpic.new(:avatar=>params["onlinemall"]["mallpic_attributes"]["0"]["avatar"])
  		if @onlinemall.valid? && mallpic.valid?
	  		@onlinemall.save
	  		mallpic.onlinemall_id = @onlinemall.id
	  		mallpic.save
	  		flash[:notice] = "Mall item added successfully"
			  redirect_to onlinemall_index_path
  		else
  			render "index"
  		end
    else
    	flash[:notice] = "Please add image"
    	render "index"
    end
  	
  end

  def mallitemassign
    logger.debug(">>>>>>>>>>>>>>>>>>>>>")
    logger.debug(params)
    onlinemall = Onlinemall.find(params[:id])
    if onlinemall.present?
      if params[:checked] == "true"
        Companymallitem.create(:onlinemall_id=>onlinemall.id,:user_id=>current_user.id)
      else
        companymallitem = Companymallitem.find_by_onlinemall_id(onlinemall.id)
        if companymallitem.present?
          companymallitem.destroy
        end
      end
    end
  end

end #main
