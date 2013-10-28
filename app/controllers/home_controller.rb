class HomeController < ApplicationController
	skip_before_filter :authenticate_user!, :only => [:calculateAmount]

def index
	@user = User.new
end

def test
end


  def calculateAmount
  	@discount_location = params[:locationDisId] > "0" ? DiscountsOnLocation.find(params[:locationDisId]) : nil
  	@discount_user = params[:userDisId] > "0" ? DiscountsOnUser.find(params[:userDisId]) : nil
    @discount_period = params[:planDisId] > "0" ? DiscountsOnPeriod.find(params[:planDisId]) : nil
  	@plan = Plan.first
  	total_amount = (@discount_location ? @discount_location.discountPercentage : 0) + (@discount_user ? @discount_user.discountPercentage : 0 ) + (@discount_period ? @discount_period.discountPercentage : 0)
    total_amount = total_amount > 0 ? (total_amount * @plan.price.to_i)/100 : 0 
  	total_amount = @plan.price.to_i - total_amount
  	respond_to do |format|
      format.json { render json: total_amount}
    end
  	
  end

  def validateEmail
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    params[:email].present? && (params[:email] =~ VALID_EMAIL_REGEX) && User.find_by(email: params[:email]).empty?
    respond_to do |format|
      format.json { render json: message}
    end
  end

end
