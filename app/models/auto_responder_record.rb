class AutoResponderRecord < ActiveRecord::Base
  attr_accessible :auto_responder_id, :mail_sent, :respond_date, :user_lead_id
  belongs_to :user_lead

  def self.save_respond_message(user_lead, user)
  	respond_message = AutoResponder.where(:user_id=>user)
  	if respond_message.present?
  		respond_message.each do|res|
  			if res.message.present? && res.day.present? && res.subject.present?
  				reps = AutoResponderRecord.new(:auto_responder_id=>res.id, :user_lead_id=>user_lead.id, :respond_date=> Date.today + res.day, :mail_sent=>false)
  				if reps.save
  				else
  				end
  			end
  		end
  	end
  end
  def self.send_auto_respond_mail
  	mailer_list = AutoResponderRecord.where(:respond_date => Date.today)
  	if mailer_list.present?
  		mailer_list.each do|ml| 
  			ul = UserLeads.find(ml.user_lead_id)
  			company = ul.user.fetchCompany
			  au = AutoResponder.find(ml.auto_responder_id)
        if ul.lead.email.present? && ul.lead.subscribe
          from_email = au.user.from_email.present? ? au.user.from_email : company.email
          unsub_url = "#{SERVER_URL}/unsubscribe?unsub=#{ul.lead.lead_token}"
  				Emailer.send_respond_mail(ul.lead.email, au.message.html_safe, au.subject, company.company_name, from_email, unsub_url).deliver
  			end
  		end 
  	end
  end
end
