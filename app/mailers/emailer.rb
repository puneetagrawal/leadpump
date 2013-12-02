class Emailer < ActionMailer::Base
  include SendGrid

  default from: "Support@LeadPump.com"
  def gmail_referral_mail(email, token, message, sec_token)
    sendgrid_category "Welcome"
    sendgrid_unique_args :key2 => "newvalue2", :key3 => "value3"
    @email = email.to_s
    @url  = "http://"+SERVER_URL+"/acceptInvitation?token=#{token}&sec=#{sec_token}&source=gmail"
    @message = message
    @trackUrl = SERVER_URL+"/trackEmail?token=#{token}&sec=#{sec_token}"
    mail(to: @email, subject: ' An invitation from  me to you')
  end
  def fb_referral_mail(email, token, message)
    @email = email.to_s
    @url  = SERVER_URL+"/acceptInvitation?token=#{token}&souce=fb"
    @message = message
    mail(to: @email, subject: 'An invitation from  me to you')
  end
  def password_reset(user, reset_token)
  	@user = user
    email = @user.email
  	@reset_token = reset_token
  	@url = SERVER_URL+"/users/password/edit?initial=true&reset_password_token=#{reset_token}"
		mail(to: email, subject: 'Set password for LEADPUMP.com employee user account')
  end
  def sendtestmail()
    sendgrid_category "Welcome"
    sendgrid_unique_args :key2 => "newvalue2", :key3 => "value3"
    @url = SERVER_URL+"/trackEmail"
    mail(to: 'puneet.agarwal@ongraph.com', subject: 'You are being tracked')
  end
end
