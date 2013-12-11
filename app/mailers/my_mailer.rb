class MyMailer < Devise::Mailer   
  #helper :application # gives access to all helpers defined within `application_helper`.

  include Devise::Mailers::Helpers # gives access to all helpers defined within `application_helper`.
  default from: "Support@LeadPump.com"
  
 def reset_password_instructions(record, token, opts={})
   @token = token
  @resource = record
  if @resource.reset_status
    mail(:to => @resource.email, :subject => "Your reset password", :content_type => "text/html") do |format|
       format.html { render "/devise/mailer/reset_password_instructions" }
     end
   else
    mail(:to => @resource.email, :subject => "Your Order Receipt", :content_type => "text/html") do |format|
       format.html { render "/devise/mailer/reset_password_instructions" }
     end
   end
 end
  
end