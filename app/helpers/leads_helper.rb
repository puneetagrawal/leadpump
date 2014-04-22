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
		text = create_note_row(lead)		
		render(:inline=> text)
	end

	def create_note_row(lead)
		text = "<tr class='note'><td>Notes</td>"
		if lead.lead_notes.present?
			lead.lead_notes.each do |ld|
				start_time = ld.time_stam 
				start_time.rfc822                          # => "Tue, 23 Feb 2010 10:58:23 -0500"
				pst = ActiveSupport::TimeZone["Pacific Time (US & Canada)"]
				time = pst.at(start_time).strftime("%m-%d-%Y %H:%M:%S") # => "08:00 AM PST"
				if text == "<tr class='note'><td>Notes</td>"
					text += "<td>#{ld.notes}</td> <td>#{time}</td></tr>"
				else
					text += "<tr class='note'> <td></td> <td>#{ld.notes}</td> <td>#{time}</td></tr>"
				end
			end
		else
			text += "<td>-</td><td></td></tr>"
		end
		return text
	end

end
