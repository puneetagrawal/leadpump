class Company < ActiveRecord::Base
   attr_accessible :company_admin_id, :company_user_id
   belongs_to :user


   def self.checkuserstatus(userId)
		user = User.find(userId)
		status = "Inactive"
		if user.present?
			status = user.active ? "Active" : "Inactive"
		end
	end

	def self.savelandpagelogo(landpage, logo)
		if landpage.land_page_logos.present? && !logo.blank?
	        landpage.land_page_logos[0].avatar = logo
	        landpage.land_page_logos[0].save
	    elsif !logo.blank?
	        landlogo = LandPageLogo.new(:avatar=>logo)
	        landlogo.landing_page_id = landpage.id 
	        landlogo.save
	    end
	end

	def self.fetchlogofromparam(params)
		logo = ''
		if params[:landing_page].has_key?(:land_page_logo)
		    logo = params[:landing_page][:land_page_logo][:avatar]
		    params[:landing_page].delete :land_page_logo
  		end
  		return logo
	end
end
