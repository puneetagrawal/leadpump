module VipleadsHelper
include ApplicationHelper
	def is_vip_allow(user)
		allow = true
		company = user.fetchCompany
		if company.present?
			if company.subscription.present?
				plan = company.subscription.plan_per_user_range.plan.name
				if plan != "Basic" && plan != "Advanced" && check_plan_expired(company)
					allow = true
				end
			end
		end
		return allow
	end
end
