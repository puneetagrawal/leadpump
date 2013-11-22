class Emailer < ActionMailer::Base
  default from: "Support@LeadPump.com"
  def gmail_referral_mail(email, token)
    @email = email.to_s
    @url  = "signin.leadpump.com/acceptInvitation?token=#{token}"
    mail(to: @email, subject: 'There is lead for you')
  end
  def password_reset(user, reset_token)
  	@user = user
    email = @user.email
  	@reset_token = reset_token
  	@url = "signin.leadpump.com/users/password/edit?initial=true&reset_password_token=#{reset_token}"
		mail(to: email, subject: 'Set password for LEADPUMP.com employee user account')
  end
end
