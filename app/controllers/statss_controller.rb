class StatssController < ApplicationController
  
  def index
    @response = HTTParty.get('https://api.sendgrid.com/api/stats.get.json?api_user=leadpump&api_key=4trading&list=true')
  	@stats = Stats.where(:user_id=>current_user.id)
    @datelist = Stats.fetchDateList
    @statsgraphdata = Stats.fetchgraphdata(current_user.id)
  end

  def statsearch
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

  def csvdownload
  	@stats = Stats.fetchuserstats(current_user)
  	respond_to do |format|
      format.html
      format.csv { send_data @stats.to_csv }
      #format.xls { send_data @stats.to_csv(col_sep: "\t") }
    end
  end
end
