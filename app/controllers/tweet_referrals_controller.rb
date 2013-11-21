class TweetReferralsController < ApplicationController

	def new
		@tw_referral  = TweetReferral.new()
		@ref = User.where(:name=>params[:token]).last
	end

	def create
		@tw_referral = TweetReferral.new(params[:tw_referral])
	    respond_to do |format|
	      if @tw_referral.save
	        format.html { redirect_to root_url, notice: 'Thank You.' }
  			viplead = VipLead.create(:first_name=>@tw_referral.name, :email=>@tw_referral.email, :active=>true, :user_id=>@tw_referral.referrer)
	        viplead.save
	      else
	        format.html { render action: "new" }
	        	end
   		  end
	end

end
