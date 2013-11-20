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
		assigntext = ''
		case user.user_role.role_type.to_sym	
		when :admin
			assigntext = 'Assign'
			user_lead = UserLeads.where(:lead_id => leadId).where('user_id != ?', current_user.id)
			if user_lead.present?
				assigntext = "Reassign"
			end
		when :company
			assigntext = 'Assign'
			user_lead = UserLeads.where(:lead_id => leadId).where('user_id != ?', current_user.id)
			if user_lead.present?
				assigntext = "Reassign"
			end
		end

		if !assigntext.blank?
			assigntext = "<span id='asignBtn_#{leadId}' class='leadAction '>
			  					| <%=link_to '#{assigntext}', 'javascript:void(0)',html={:class=>'leadAction assignLead red_lead'}%>
							</span>"

		end
		return render(:inline=> assigntext)
	end	 

	

end
