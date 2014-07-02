class OnlinemallController < ApplicationController
  def index
    @onlinemall = Onlinemall.new
    if current_user.isAdmin
      @onlinemalls = Onlinemall.includes(:mallpic).includes(:user).order("created_at DESC")
    elsif current_user.isCompany
    	@onlinemalls = Onlinemall.includes(:mallpic).includes(:user).order("created_at DESC").where(:user_id=>[current_user,1])
    else
      redirect_to dashboard_path
    end
  end

  def create
    @onlinemall = Onlinemall.new(:description=>params[:onlinemall][:description], :title=>params[:onlinemall][:title], :link=>params[:onlinemall][:link], :file => params[:onlinemall][:file],:user_id=>current_user.id)
  	mallpic = nil
  	if !params["onlinemall"]["mallpic_attributes"]["0"]["avatar"].blank?
  		mallpic = Mallpic.new(:avatar=>params["onlinemall"]["mallpic_attributes"]["0"]["avatar"])
  		if @onlinemall.valid? && mallpic.valid?
	  		@onlinemall.save
	  		mallpic.onlinemall_id = @onlinemall.id
	  		mallpic.save
        if current_user.isCompany
          Companymallitem.create(:onlinemall_id=>@onlinemall.id,:user_id=>current_user.id)
        end
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
    msg = {"msg" => "success"}
    respond_to do |format|
      format.json { render json: msg}
    end
  end

  def edit   
    @onlinemall = Onlinemall.find(params[:id])   
    respond_to do |format|
        format.js 
    end 
  end

  def update  
    @mallupdate = Onlinemall.find(params[:id]) 
    @mallupdate.update_attributes(:description=>params[:onlinemall][:description], :title=>params[:onlinemall][:title],:link=>params[:onlinemall][:link], :file => params[:onlinemall][:file])
    if params[:onlinemall].has_key?(:mallpic_attributes)
      @mallupdate.mallpic[0].avatar = params["onlinemall"]["mallpic_attributes"]["0"]["avatar"]
      if @mallupdate.mallpic[0].save
      else
        logger.debug(@mallupdate.errors.fullmessage)
      end
    end
    flash[:notice] = "Mall item updated successfully"
    redirect_to onlinemall_index_path
  end

  def mallremove
    onlinemall = Onlinemall.find(params[:id])
    if onlinemall.present?
      onlinemall.mallpic[0].destroy
      company = Companymallitem.where(:onlinemall_id=>onlinemall.id)
      company.destroy_all
      onlinemall.destroy
    end
    msg = {"msg" => "Successfully Deleted"}
    respond_to do |format|
      format.json { render json: msg}
    end
  end

end #main
