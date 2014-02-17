module SaleProdsHelper
	include ApplicationHelper
	def is_daily_rep_allow(user)
		allow = false
		company = user.fetchCompany
		if company.present?
			if company.subscription.present?
				plan = company.subscription.plan_per_user_range.plan.name
				if plan != "Basic" && check_plan_expired(company)
					allow = true
				end
			end
		end
		return allow
	end
end
