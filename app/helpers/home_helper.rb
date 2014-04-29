module HomeHelper

def create_verify_text()
	text = "<div class='thanku_col'><p class='heading'>Thank you!<p>"
	text += "<p>Please login into your account you provided and click the 'account activation' link. You will then be redirected to our site.</p>"
	text += "<p>If the email does not appear in your inbox please be sure to check your spam folder.</p></div>"
	return text
end

def get_logs_class(feed)
	if feed.description == "New Optin Lead"
		return "red_table_strip"
	elsif feed.description == "New POS Lead"
		return "yellow_table_strip"
	else
		return "green_table_strip"
	end
end

def get_feed_icon(feed)
	if feed.description == "Meeting - Tour or Signup"
		return '<img width="25" src="/assets/hand.png"/>'.html_safe
	else
		return '<img width="25" src="/assets/phone_icon1.png"/>'.html_safe
	end
end

end
