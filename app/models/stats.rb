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
	   	stats = Stats.where("user_id = ? and created_at >= ? and created_at < ?",user,Date.today, Date.today+1).last
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
   	stats = Stats.where("user_id = ? and created_at >= ? and created_at < ?",user,Date.today, Date.today+1).last
   	msg = "Sorry! your link is invalid or expired."
   	if recipient.present? && !recipient.opt_in
      recipient.update_attributes(:opt_in=>true)
      if stats.present?
		    converted = stats.e_converted.present? ? stats.e_converted + 1 : 1
		    stats.update_attributes(:e_converted=>converted)
      else
        Stats.create(:e_converted=>1,:user_id=>user)
      end
      msg = "Thanks.You are successfuly Opt in."
   end
	return msg
  end

  def self.saveEvisited(user, recipient)
   	stats = Stats.where("user_id = ? and created_at >= ? and created_at < ?",user,Date.today, Date.today+1).last
    if recipient.present? && !recipient.visited
      recipient.update_attributes(:visited=>true)
     	if stats.present?
     		views = stats.e_views.present? ? stats.e_views + 1 : 1
  	    stats.update_attributes(:e_views=>views)
  	  else
        Stats.create(:e_views=>1,:user_id=>user)
      end
    end
  end

  def self.saveEoppened(gmailfriend)
    if gmailfriend.present? 
      if !gmailfriend.oppened
        gmailfriend.update_attributes(:oppened=>true)
        stats = Stats.where("user_id = ? and created_at >= ? and created_at < ?",gmailfriend.user_id,Date.today, Date.today+1).last
        if stats.present?
          opened = stats.e_oppened.present? ? stats.e_oppened + 1 : 1
          stats.update_attributes(:e_oppened=>opened)
        else
          Stats.create(:e_oppened=>1,:user_id=>user)
        end
      end
    end
  end

  def self.fetchuserstats(user)
    stats = []
    case user.user_role.role_type.to_sym  
    when :employee
      stats = Stats.where(:user_id=>user.id)
    when :company
      users = User.fetchCompanyUserList(user)
      users << user
      stats = Stats.where(:user_id=>users)
    end
  end

  def self.fetchDateList()
    date = Date.today
    return "#{(date-30).strftime("%b %d")}, #{(date-27).strftime("%b %d")}, #{(date -24).strftime("%b %d")},#{(date-21).strftime("%b %d")},#{(date-18).strftime("%b %d")},#{(date-15).strftime("%b %d")},#{(date-12).strftime("%b %d")},#{(date-9).strftime("%b %d")},#{(date-6).strftime("%b %d")},#{(date-3).strftime("%b %d")},#{(date).strftime("%b %d")}"
  end

  def self.fetchgraphdata(user)
    e_sent = ''
    e_converted = ''
    e_views = ''
    dates = ''
    date = Date.today.at_beginning_of_month
    date_cur = Date.today.at_end_of_month
    logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>")
    logger.debug(Date.today.at_beginning_of_month)
    logger.debug(Date.today.at_end_of_month)
    (date..date_cur).each do|dd| 
      logger.debug("#{dd} -- #{dd+1}")
      stats = Stats.where("updated_at >= ? and updated_at < ? and user_id = ?",dd, dd+1, user.id)
      e_converted += "#{stats.collect{|stat| stat.e_converted}.compact.inject(0, :+)},"
      e_views += "#{stats.collect{|stat| stat.e_views}.compact.inject(0, :+)},"
      e_sent += "#{stats.collect{|stat| stat.e_sents}.compact.inject(0, :+)},"
    end
    dates = "#{1}, #{(Date.today).strftime("%b")} - #{Date.today.at_end_of_month.day}, #{Date.today.strftime("%b")}"
    return {:e_con=>e_converted, :e_view=>e_views,:e_sent=>e_sent,:dates=>dates}
  end

end #main
