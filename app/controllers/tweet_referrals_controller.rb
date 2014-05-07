class TweetReferralsController < ApplicationController

	def new
		@tw_referral  = TweetReferral.new()
		if params[:token].present?
			@ref = User.where(:name=>params[:token]).last
		end
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

	def savereferral
		referrals = TweetReferral.where(:email=>params[:email], :referrer=>params[:ref_id])
		if !@tw_referral.present?
			msg = "Thank you! You have done.Will get you soon."
			TweetReferral.create(:email=>params[:email], :referrer=>params[:ref_id], :name=>params[:name])
    	else
    		msg = "Token looks invalid or expired."
		end
		message = {"msg" => msg}
		respond_to do |format|
			format.json { render json: message}
		end
	end


end
