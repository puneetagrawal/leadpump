class HomeController < ApplicationController
	skip_before_filter :authenticate_user!, :only => [:calculateAmount]

def index
	@user = User.new
end

def test
end


  def calculateAmount
    @plan = params[:planId] ? Plan.find(params[:planId]) : nil
    #discountOnUsers = du != '' ? DiscountsOnUser.find(du).discountPercentage : 0
    du = params[:du] != '' ? params[:du] : 1
    no_of_users = du.to_i
    dl = params[:dl]!= '' ? params[:dl] : 1
    dl = dl.to_i
    dp = params[:dp].to_i
    charges = 0
    chargesList = []
    locationCharge = 0
    @discountOnLocation = nil

    i = 1
    minNoOfLocation = 1
    if @plan.name == 'Advanced'
      i = 2
    elsif @plan.name == 'Proffessional'
      i = 3
    elsif @plan.name == 'Proffessional Plus'
      i = 4
    end 
    if(dl <= 1)
        @discountOnLocation = dl != '' ? DiscountsOnLocation.find(1) : nil      
    elsif (dl > 1 && dl <= 2)
        @discountOnLocation = dl != '' ? DiscountsOnLocation.find(2) : nil
        minNoOfLocation = 11
    elsif (dl > 2 && dl <= 3)
        @discountOnLocation = dl != '' ? DiscountsOnLocation.find(3) : nil
        minNoOfLocation = 21
    elsif (dl > 3 && dl <= 4)
        @discountOnLocation = dl != '' ? DiscountsOnLocation.find(4) : nil
        minNoOfLocation = 51
    end

    chargesList = @discountOnLocation ? @discountOnLocation.chargePerUser.split(",") : []
    charges = chargesList.size > 0 ? chargesList[i].to_i : 0
    locationCharge = chargesList.size > 0 ? chargesList[0].to_i : 0
    lcStr = "$#{locationCharge} * #{minNoOfLocation} = $#{locationCharge * minNoOfLocation}"
    locationCharge = locationCharge * minNoOfLocation if locationCharge > 0

    bcStr = "$#{charges} * #{no_of_users} = $#{no_of_users * charges}"
    charges_per_user = no_of_users * charges
    
    total_charge = locationCharge + charges
    discountOnLocations = @discountOnLocation ? @discountOnLocation.discountPercentage : 0
    discountonPeriod = dp 
    amount = discountOnLocations + discountonPeriod
    amount =  amount * total_charge
    amount = amount/100
    totalDis = "$#{amount}"
    amount = total_charge - amount
    @msg = { "lcStr" => lcStr, "bcStr" => bcStr, "totalDis" => totalDis, "amount" => "$#{amount}"}
    respond_to do |format|
      format.json { render json: @msg}
    end
  	
  end

end
