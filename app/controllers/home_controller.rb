class HomeController < ApplicationController
	skip_before_filter :authenticate_user!, :only => [:calculateAmount]

def index
	@user = User.new
end

def test
end


  def calculateAmount
    puts ">>>>>>>>>>>>>>>>>>>>>>>>"
  	puts params

    @plan = params[:planId] ? Plan.find(params[:planId]) : nil
    #discountOnUsers = du != '' ? DiscountsOnUser.find(du).discountPercentage : 0
    du = params[:du] != '' ? params[:du].to_i : 1
    no_of_users = du
    dl = params[:dl]!= '' ? params[:dl].to_i : 0
    dp = params[:dp]!= '' ? params[:dp].to_i : 1    
    charges = 0
    chargess = 0
    locationCharge = 0
    @discountOnLocation = nil
    puts @plan.name

    if @plan.id == 'Basic'
      i = 1
    elsif @plan.name == 'Advanced'
      i = 2
    elsif @plan.name == 'Proffessional'
      i = 3
    elsif @plan.name == 'Proffessional Plus'
      i = 4
    end 
    puts i
    puts dl
    dl = dl.to_i
    if(dl <= 1)
        @discountOnLocation = dl != '' ? DiscountsOnLocation.find(1) : nil      
    elsif (dl > 1 && dl <= 2)
        @discountOnLocation = dl != '' ? DiscountsOnLocation.find(2) : nil
    elsif (dl > 2 && dl <= 3)
        @discountOnLocation = dl != '' ? DiscountsOnLocation.find(3) : nil
    elsif (dl > 3 && dl <= 4)
        @discountOnLocation = dl != '' ? DiscountsOnLocation.find(4) : nil
    end
    puts @discountOnLocation.id
    chargess = @discountOnLocation ? @discountOnLocation.chargePerUser.split(",") : []
    charges = chargess ? chargess[i] : 0
    locationCharge = chargess ? chargess[0] : 0
    lcStr = "$#{locationCharge} * #{dl} = $#{locationCharge.to_i * dl.to_i}"
    locationCharge = locationCharge.to_i * dl.to_i
    bcStr = "$#{charges} * #{no_of_users} = $#{no_of_users * charges.to_i}"

    charges = no_of_users.to_i * charges.to_i
    total_charge = locationCharge.to_i + charges.to_i

    discountOnLocations = @discountOnLocation ? @discountOnLocation.discountPercentage : 0
    discountonPeriod = dp != '' ? 10 : 0
    amount = discountOnLocations + discountonPeriod
    amount =  amount.to_i * total_charge.to_i
    amount = amount/100
    totalDis = "$#{amount}"
    amount = total_charge - amount
    @msg = { "lcStr" => lcStr, "bcStr" => bcStr, "totalDis" => totalDis, "amount" => "$#{amount}"}
    respond_to do |format|
      format.json { render json: @msg}
    end
  	
  end

end
