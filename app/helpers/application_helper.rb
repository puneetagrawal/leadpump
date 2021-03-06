module ApplicationHelper

	
	def get_bg_color
		if (controller_name == "plans" && action_name == "new") || (controller_name == "home" && action_name == "intouch") || (controller_name == "home" && action_name == "index")
			return "graybg"
		end
	end

	def wicked_pdf_image_tag_for_public(img, options={})
		if img[0] == "/"
			new_image = img.slice(1..-1)
			image_tag "file://#{Rails.root.join('public', new_image)}", options
		else
			image_tag "file://#{Rails.root.join('public', 'images', img)}", options
		end
	end

	def check_plan_expired(user)
		allow = true
		date = user.subscription.expiry_date
		if date < Date.today
			allow = false
		end
		return allow
	end

	def upgrade_user(user)
		subscription = user.fetchCompany.subscription
		if subscription.present?
			range = subscription.plan_per_user_range.user_range.end_range
			upgrade_range = UserRange.where("start_range > ?",range).first
			if upgrade_range.present?
				return upgrade_range.id
			else
				return 5
			end
		end
	end
	
	def check_trial_period(user)
		allow = false
		if user.isCompany
			if user.trial && user.subscription.charge_id.blank?
				allow = true
			end
		end
		return allow
	end

end
