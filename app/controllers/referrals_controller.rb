class ReferralsController < ApplicationController

	def new
		@referral  = Referral.new()
		@ref = User.where(:name=>params[:token]).last
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

end
