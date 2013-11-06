module LeadsHelper

	def fetchLeadEmployee(leadId)
		user_lead = UserLeads.find_by_lead_id(leadId)
		employee = ""
		if user_lead
			case user_lead.user.user_role.role_type.to_sym			
			when :employee
				employee = user_lead.user.name	
			end
		end
		return employee	
	end

	def checkIfCompanyAdmin
		user = User.find(current_user.id)
		company= false
		case user.user_role.role_type.to_sym			
		when :company
			company = true
		end
		return company	
	end	 

end
