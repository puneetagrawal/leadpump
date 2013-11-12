module LeadsHelper

	def fetchLeadEmployee(leadId)
		user_lead = UserLeads.where(:lead_id => leadId).where('user_id != ?', current_user.id) 
		employee = ""
		case current_user.user_role.role_type.to_sym			
		when :company
			if user_lead.present?
				employee = user_lead[0].user.name
			end
		when :employee
			employee = current_user.name
		end
		return employee	
	end

	def checkIfCompanyAdmin(leadId)
		user = User.find(current_user.id) 	
		company = false
		case user.user_role.role_type.to_sym	
		when :admin
			company = true		
		when :company
			user_lead = UserLeads.where(:lead_id => leadId).where('user_id != ?', current_user.id)
			company = user_lead.size > 0 ? false : true
		end
		return company	
	end	 

	

end
