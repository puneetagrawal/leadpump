class Stats < ActiveRecord::Base
   attr_accessible :source, :location, :e_sents, :e_oppened, :e_views, :e_converted, :user_id

   belongs_to :user

   def self.to_csv(options = {})
      CSV.generate(options) do |csv|
        csv << ["Offer-Source", "Location","Associate","Email-Sent","Email-Opened","Conversion-page views","Lead Conversions","Date Sent"]
        all.each do |stat|
          csv << [stat.source, stat.location, stat.user.name, stat.e_sents, stat.e_oppened, stat.e_views, stat.e_converted, stat.created_at.strftime("%Y-%m-%d %I:%M:%p")]
        end
      end
    end

   def self.saveEsents(user, sents_count, email)
   	recipient = GmailFriend.where(:email=>email, :user_id=>user).last
   	if recipient.present? && !recipient.sent
   		recipient.update_attributes(:sent=>true)
	   	stats = Stats.find_by_user_id(user)
	    if stats.present?
	      sent = stats.e_sents.present? ? stats.e_sents + 1 : 1
	      stats.update_attributes(:e_sents=>sent)
	    else
	      Stats.create(:user_id=>user,:e_sents=>sents_count)
	    end
	end
   end

   def self.saveEconverted(user, sec_token)
   	recipient = GmailFriend.find_by_secret_token(sec_token)
   	stats = Stats.find_by_user_id(user)
   	msg = "Sorry! your link is invalid or expired."
   	if stats.present?
	   	if recipient.present? && !recipient.opt_in
	   		recipient.update_attributes(:opt_in=>true)
		    converted = stats.e_converted.present? ? stats.e_converted + 1 : 1
		    stats.update_attributes(:e_converted=>converted)
		    msg = "Thanks.You are successfuly Opt in."
	    end
	end
	return msg
  end

  def self.saveEvisited(user, recipient)
   	stats = Stats.find_by_user_id(user)
   	if stats.present?
   		recipient.update_attributes(:visited=>true)
   		views = stats.e_views.present? ? stats.e_views + 1 : 1
	    stats.update_attributes(:e_views=>views)
	  end
  end

  def self.saveEoppened(gmailfriend)
    if gmailfriend.present? 
      if !gmailfriend.oppened
        gmailfriend.update_attributes(:oppened=>true)
        stats = Stats.find_by_secret_token(gmailfriend.user_id)
        if stats.present?
          opened = stats.e_oppened.present? ? stats.e_oppened + 1 : 1
          stats.update_attributes(:e_oppened=>opened)
        end
      end
    end
  end

  def self.fetchuserstats(user)
    stats = []
    case user.user_role.role_type.to_sym  
    when :employee
      stats = Stats.where(:user_id=>current_user.id)
    when :company
      users = User.fetchCompanyUserList(user)
      users << user
      stats = Stats.where(:user_id=>users)
    end
  end

end #main
