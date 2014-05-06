class StatssController < ApplicationController
  include VipleadsHelper
  before_filter :check_plan, :only => [:index]
  def index
    @response = HTTParty.get('https://api.sendgrid.com/api/stats.get.json?api_user=leadpump&api_key=4trading&list=true')
  	@stats = Stats.includes(:user).where(:user_id=>current_user.id)
    @datelist = Stats.fetchDateList
    @statsgraphdata = Stats.fetchgraphdata(current_user)
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


  private 
  def check_plan
    if !is_vip_allow(current_user)
      flash[:notice] = "Sorry! you are not authorize user"
      redirect_to dashboard_path
    end
  end
end
