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

	def self.createUser(useradmin, user)
		logger.debug(useradmin)
		logger.debug(user)
		company = Company.new(:company_admin_id => useradmin.id, :company_user_id => user.id)
        company.save
        useradmin.update_attributes(:users_created=> useradmin.users_created+1)
        begin 
          user.send_reset_password_instructions
        rescue Exception => e
        end
        user.update_attributes(:reset_status => false)
        return user
    end

    def self.removeAllPrintPassSessions(session)
    	TemporaryData.first.update_attributes(:fn=>"",:add=>"",:zp=>"",:ag=>"",:ct=>"",
    		:em=>"",:ph=>"",:gst=>"",:st=>"",:cex=>"",:hc=>"",:fg=>"")
    end

    def self.report
		user_ary = []
		ary = [106,127,140]
      	ary.each do |a|
	        u = User.find(a)
	        user_list = User.fetchCompanyUserList
	        user_count = user_list.size
	        opts = UserLeads.includes(:lead).where("leads.lead_source = ? and user_id = ?", "LEADPUMP optin", u.id).count
	        p_o_s = UserLeads.includes(:lead).where("leads.lead_source = ? and user_id = ?", "LEADPUMP p.o.s.", u.id).count
	        mail_oppened_count = Stats.where("user_id = ?", u.id).pluck(:e_oppened).count
	        mail_sent_count =  Stats.where("user_id = ?", u.id).pluck(:e_sents).count
	        mail_converted_count = Stats.where("user_id = ?", u.id).pluck(:e_converted).count
	        crnt_user = current_user.email
	        to = u.email
	        Emailer.report_mailer(opts, p_o_s, mail_oppened_count, mail_sent_count , mail_converted_count, crnt_user, to ).deliver
      	end

	end
end
