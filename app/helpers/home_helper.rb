module HomeHelper

def create_verify_text()
	text = "<div class='thanku_col'><p class='heading'>Thank you!<p>"
	text += "<p>Please login into your account you provided and click the 'account activation' link. You will then be redirected to our site.</p>"
	text += "<p>If the email does not appear in your inbox please be sure to check your spam folder.</p></div>"
	return text
end

def get_logs_class(feed)
	if feed.description == "New Guest Pass Request"
		return "red_table_strip"
	elsif feed.description == "New POS Lead" || feed.description == "New Data Entry Lead"
		return "yellow_table_strip"
	else
		return "green_table_strip"
	end
end

def get_feed_icon(feed)
	if feed.description == "Meeting - Tour or Signup"
		return '<img width="25" src="/assets/hand.png"/>'.html_safe
	elsif feed.description == "Guest Pass Expiring"
		return '<img width="25" src="/assets/calender.png"/>'.html_safe
	else
		return '<img width="25" src="/assets/phone_icon1.png"/>'.html_safe
	end
end

def get_waiver_text(user)
	# binding.pry
	logger.debug(">>>.>>>>>>>>>>>>>>>>>>>>>>>>")
	text = user.front_desk_desc.present? && !user.front_desk_desc.description.blank? ? user.front_desk_desc.description : FrontDeskDesc::DESC
end

def get_waiver_title(user)
	logger.debug(">>>.>>>>>>>>>>>>>>>>>>>>>>>>")
	if user.front_desk_desc.present? && !user.front_desk_desc.title.blank?
	  return user.front_desk_desc.title
	else
		return nil
	end
end

end
