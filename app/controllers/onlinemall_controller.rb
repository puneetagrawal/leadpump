class OnlinemallController < ApplicationController
  def index
  	@onlinemalls = Onlinemall.all
  	@onlinemall = Onlinemall.new
  end

  def create
  	@onlinemall = Onlinemall.new(:title=>params[:onlinemall][:title], :link=>params[:onlinemall][:link],:user_id=>current_user.id)
  	mallpic = Mallpic.new(:avatar=>params[:onlinemall][:mallpic][:avatar])
  	if onlinemall.valid? && mallpic.valid?
  		onlinemall.save
  		mallpic.onlinemall_id = onlinemall.id
  		mallpic.save
	else
		render "index"
	end
	flash[:notice] = "Mall item added successfully"
	redirect_to onlinemall_index_path
  end

end #main
