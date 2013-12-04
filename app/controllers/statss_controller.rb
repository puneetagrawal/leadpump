class StatssController < ApplicationController
  
  def index
    response = HTTParty.get('https://api.sendgrid.com/api/stats.get.json?api_user=leadpump&api_key=4trading&list=true')
  	@stats = Stats.where(:user_id=>current_user.id)
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
