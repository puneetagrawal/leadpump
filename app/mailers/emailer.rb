class Emailer < ActionMailer::Base
  default from: "vishuatdev@gmail.com"
  def gmail_referral_mail()
    #@user = user
    email = "vishwanath.yadav@ongraph.com"
    #@gmailcontact = gmailcontact
    @url  = 'localhost:3000/users/password/edit?initial=true&reset_password_token=reset_token'
    mail(to: email, subject: 'There is lead for you')
  end
  def password_reset(user, reset_token)
  	@user = user
  	@reset_token = reset_token
  	logger.debug(">>*************")
  	logger.debug(@user.reset_password_token)
  	@url = "localhost:3000/users/password/edit?initial=true&reset_password_token=#{reset_token}"
  	logger.debug(">>>>>>>>>>>>>")
  	logger.debug @url
		
		mail(to: "vs9170@gmail.com", subject: 'you are created')
  end
end
