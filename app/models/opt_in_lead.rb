class OptInLead < ActiveRecord::Base
  attr_accessible :email, :source, :phone, :name, :referrer_id

  translates :name, :source
  
  belongs_to :user


	# def self.fetchOptInLead(user)
	# 	leads = []
	# 	userList = []
	# 	leads_id = Lead.where("lead_source = ? or lead_source = ?","fb","twitter").pluck(:id)
	# 	case user.user_role.role_type.to_sym  
	#     when :admin
	#       leads = UserLeads.includes(:lead).where(:lead_id=>leads_id)
	#     when :company
	#       userList = Company.where(:company_admin_id => user.id).pluck(:company_user_id)
	#       users = userList
	#       userList << user.id
	#       leads = UserLeads.select("distinct(lead_id)").where(:user_id => userList).where(:lead_id=>leads_id)
	#     when :employee
	#       leads = UserLeads.includes(:lead).where(:user_id => user.id).where(:lead_id=>leads_id)
	#     end
	#     return leads
	# end

	def self.assignOptinToAdmin(object)
		if object.isEmployee
			optin = OptInLead.where(:referrer_id=>object.id)
			if optin.present?
				company = object.fetchCompany
				optin.each do |opt|
					opt.referrer_id = company.id
					opt.save
				end
			end
		end
	end

end
