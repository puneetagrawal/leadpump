class StatssController < ApplicationController
  
  def index
  	@stats = Stats.where(:user_id=>current_user.id)
  end

  def statsearch
  	logger.debug(">>>>>>>>>>>>>>>>>")
	  if params[:term].blank?
	   stats = Stats.select("distinct(source)").where("user_id = ?", current_user.id)
	   list = stats.map {|s| Hash[id: s.id, label: s.source, name: s.source]}
	  else
	   like  = "%".concat(params[:term].concat("%"))
	   stats = Stats.select("distinct(source)").where("source like ?", like).where(:user_id=>current_user.id)
	   list = stats.map {|s| Hash[id: s.id, label: s.source, name: s.source]}
	 end
	 render json: list
	end

end
