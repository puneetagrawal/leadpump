module ApplicationHelper
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
		if date > Date.today
			allow = true
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

	end
