class HomeController < ApplicationController
	skip_before_filter :authenticate_user!, :only => [:calculateAmount]

    def index
    	@user = User.new
    end

    def test
    end


    def calculateAmount
        @msg = User.signUpAmount(params[:planId], params[:du], params[:dl], params[:dp])
        respond_to do |format|
          format.json { render json: @msg}
        end
    end

end
