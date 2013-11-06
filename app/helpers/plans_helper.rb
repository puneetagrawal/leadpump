module PlansHelper

def is_number?
  self.to_f == self
end

def fetechPlanLeadmanagementText(lead_management)
	text = "Up to #{lead_management} Contacts"
	if /\D+/.match(lead_management)
		text = lead_management
	end
	return text
end	

def unlimitedText(data)
	class_name = ""
	if /\D+/.match(data)
		class_name = 'unlimited'
	end
	return class_name
end

end
