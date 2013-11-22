class Emailer < ActionMailer::Base
  default from: "Support@LeadPump.com"
  def gmail_referral_mail(email, token)
    @email = email.to_s
    @url  = "localhost:3000/acceptInvitation?token=#{token}"
    mail(to: @email, subject: 'There is lead for you')
  end
  def password_reset(user, reset_token)
  	@user = user
    email = @user.email
  	@reset_token = reset_token
  	logger.debug(">>*************")
    logger.debug(email)
  	logger.debug(@user.reset_password_token)
  	@url = "localhost:3000/users/password/edit?initial=true&reset_password_token=#{reset_token}"
  	logger.debug(">>>>>>>>>>>>>")
  	logger.debug @url
		
		mail(to: email, subject: 'Set password for LEADPUMP.com employee user account')
  end
end
