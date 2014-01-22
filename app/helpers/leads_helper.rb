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
			  					| <%=link_to '#{assigntext}', 'javascript:void(0)',html={:class=>'leadAction assignLead'}%>
							</span>"

		end
		return render(:inline=> assigntext)
	end	 

	def fetchTasklink(leadId)
		user = User.find(current_user.id) 	
		tasktext = 'Task'
		case user.user_role.role_type.to_sym	
		when :normalUser
			tasktext = ''
		end
		if tasktext != ''
			app = Appointment.find_by_lead_id(leadId)
			if app.present?
				tasktext = "ReTask"	
			end
			tasktext = "<%=link_to '#{tasktext}', 'javascript:void(0)',html={:class=>'leadAction task'}%>"
			return render(:inline=> tasktext)
		end

	end

	def gettimestams(lead)
		text = ''
		if lead.lead_notes.present?
			lead.lead_notes.each do |ld|
				logger.debug(ld.notes)
				logger.debug(ld.time_stam.strftime('%a %b %d %H:%M:%S %Z %Y'))
				if text == ''
					text += "<tr><td>Notes</td><td>"
				else
					text += "<tr><td></td><td>"
				end
				
				text += "#{ld.notes}"
				text += "</td><td>"
				text += "#{ld.time_stam.strftime('%a %b %d %H:%M:%S %Y')}"
				text += "</td></tr>"
			end
		end
		render(:inline=> text)
	end
end
