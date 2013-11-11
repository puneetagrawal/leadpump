class HomeController < ApplicationController
	skip_before_filter :authenticate_user!, :only => [:calculateAmount]

    def index
    	@user = User.new
    end

    def test
    end


    def calculateAmount
        @msg = User.signUpAmount(params[:plan_per_user_range], params[:du], params[:dp])
        respond_to do |format|
          format.json { render json: @msg}
      end
  end  

  def fillpopupcontent
    if(params[:urls].include? 'company')
      @user = User.find(params[:id])
    else
      @lead = Lead.find(params[:id])
    end
      logger.debug(@lead)
      logger.debug(">>>ifddffdfdf")
      logger.debug(@user)

  respond_to do |format|
    format.js 
  end
end


end
