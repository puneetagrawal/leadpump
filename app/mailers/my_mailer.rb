class MyMailer < Devise::Mailer   
  helper :application # gives access to all helpers defined within `application_helper`.


  def reset_password_instructions(record, opts={})
    headers = {
        :subject => "Welcome  #{resource.name}, reset your Qitch.com password"
    }
    super
  end
  
end