class Emailer < ActionMailer::Base
  default from: "Support@LeadPump.com"
  def gmail_referral_mail(email, token, message)
    @email = email.to_s
    @url  = SERVER_URL+"/acceptInvitation?token=#{token}&source=gmail"
    @message = message
    mail(to: @email, subject: 'There is lead for you')
  end
  def fb_referral_mail(email, token, message)
    @email = email.to_s
    @url  = SERVER_URL+"/acceptInvitation?token=#{token}&souce=fb"
    @message = message
    mail(to: @email, subject: 'There is facebook message')
  end
  def password_reset(user, reset_token)
  	@user = user
    email = @user.email
  	@reset_token = reset_token
  	@url = SERVER_URL+"/users/password/edit?initial=true&reset_password_token=#{reset_token}"
		mail(to: email, subject: 'Set password for LEADPUMP.com employee user account')
  end
end
