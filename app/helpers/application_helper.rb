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
	
end
