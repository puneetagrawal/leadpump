module VipleadsHelper
include ApplicationHelper
	def is_vip_allow(user)
		allow = false
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

	def social_invite_page
		if action_name == "new" && controller_name == "vipleads"
			return "hide"
		end
	end

	def fetch_header_logo(user)
	  logo_html = ''
	  if user && user.isAdmin
       logo_html = '<a href='+admin_index_path+'><img src=/assets/logo_img.png /></a>'   
      elsif action_name == "new" && controller_name == "vipleads"
      	if user.picture.present? && user.picture.company_logo(:head_logo).present?
       		logo_html = '<a href='+dashboard_path+'><img src='+user.picture.company_logo.url(:head_logo)+' class="vip_head_img"/></a>'   
       	else
       		logo_html = '<a href='+dashboard_path+'><img src=/assets/logo_img.png /></a>'   
       	end
      else
       logo_html = '<a href='+dashboard_path+'><img src=/assets/logo_img.png /></a>'   
      end
      render(:inline=> logo_html)
	end
end
