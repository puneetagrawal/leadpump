class Emailer < ActionMailer::Base
  include SendGrid
  helper :referrals

  default from: "LeadPump@Leadpump.com"
  def gmail_referral_mail(email, token, message, sec_token, subject, url, u_email)
    sendgrid_category "Welcome"
    sendgrid_unique_args :key2 => "newvalue2", :key3 => "value3"
    @email = email.to_s
    @url  = url
    @message = message
    u_email = u_email.to_s
    @trackUrl = SERVER_URL+"/trackEmail?token=#{token}&sec=#{sec_token}"
    mail(from:u_email, to: @email, subject: subject)
  end

  def fb_referral_mail(email, token, message, subject, url, u_email)
    @email = email.to_s
    @url  = url
    @message = message
    u_email = u_email.to_s
    mail(from:u_email,to: @email, subject: subject)
  end

  def password_reset(user, reset_token)
  	@user = user
    email = @user.email
  	@reset_token = reset_token
  	@url = SERVER_URL+"/users/password/edit?initial=true&reset_password_token=#{reset_token}"
		mail(to: email, subject: 'Set password for LEADPUMP.com employee user account')
  end

  def sendrewards(email, cmpny, company_email,user_token)
    @url = SERVER_URL+"/mallitems/#{user_token}"
    email = email.to_s
    mail(from: "#{cmpny} <#{company_email}>",to: email, subject: 'Welcome to the club')
  end
  
  def sendtestmail()
    user = "user2"
    headers "X-SMTPAPI" => {
      category:    [ "socailReferring" ],
      unique_args: { environment: Rails.env, arguments: user }
    }.to_json
    @url = SERVER_URL
    mail(to: 'vishwanath.yadav@ongraph.com', subject: 'You are being tracked')
  end

  def invite_friends(message, email)
    @message = message
    mail(:to => email, :subject => "Join LeadPump")
  end

  def send_upgrade_mail(email,name, user_email)
    mail(:from=> "#{name} <#{company_email}>", :to => email, :subject => "Please upgrade your account")
  end

  def send_respond_mail(email, message, subject, c_name, c_email, unsub_url)
    @message = message
    @email = email
    @unsub_url = unsub_url
    mail(:from=> "#{c_name} <#{c_email}>",:to => email, :subject => subject)
  end
  def report_mailer(opts, p_o_s, user, to )
    @opts = opts
    @p_o_s = p_o_s
    user = user
    to = to
    logger.debug "!!!!!!!!!!!!!!!"
    # u.each do |to|
    #   logger.debug ">>>>>>>>>>>"
    #   logger.debug to
      mail(:from=> "#{user}", :to => "#{to}", :subject => "report" )
    # end

  end

end
