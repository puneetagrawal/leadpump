class ReferralsController < ApplicationController

	def new
		@referral  = Referral.new()
		if params[:token].present?
			@ref = User.where(:token=>params[:token]).last
		end
	end

	def create
		@referral = Referral.new(params[:referral])
		email = Referral.where(:email=>params[:referral][:email], :referrer=>params[:referral][:referrer])
 	  if email.present?
	  	raise "You are already registered..!!"
	  	render :action => "new"
	  else
	 	 if @referral.save
	        format.html {  redirect_to root_url, notice: 'Thank You.' }
	       	viplead = VipLead.create(:first_name=>@referral.name, :email=>@referral.email, :active=>true, :user_id=>@referral.referrer)
	        viplead.save
	  		end
	   end
	end

	def savereferral
		referrals = Referral.where(:email=>params[:email], :referrer=>params[:ref_id])
		if !@referral.present?
			msg = "Thank you! You have done.W'll get you soon."
			Referral.create(:email=>params[:email], :referrer=>params[:ref_id], :name=>params[:name])
    	else
    		msg = "Token looks invalid or expired."
		end
		message = {"msg" => msg}
		respond_to do |format|
			format.json { render json: message}
		end
	end

end
