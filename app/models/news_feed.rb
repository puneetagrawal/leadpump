class NewsFeed < ActiveRecord::Base
  attr_accessible :action, :description, :feed_date, :user_id, :lead_id

  belongs_to :user
  belongs_to :lead

  def self.get_today_news(user, date)
    feeds = NewsFeed.includes(:lead).where("leads.id IS NOT NULL").where('user_id = ? and feed_date >= ?', user.id, date - 1).where('action = ? or action = ?',"Start", "Finish")
    return feeds
  end

  def self.get_backlogs(user, date)
    feeds = NewsFeed.includes(:lead).where("leads.id IS NOT NULL and user_id = ? and feed_date < ? and (action = ? or action = ?)",user.id, date, "Start", "Finish").group_by{|g| g.feed_date}
    return feeds
  end

  def feed_click
    if self.action == "Start"
      return "listView"
    else
      return "read_feed"
    end
  end

  def self.update_feed_action(lead, action)
    feed = NewsFeed.find_by_lead_id(lead)
    feed.action = action
    feed.save
  end

  def color
    return  self.action == "Start" ? "red" : "green"
  end

  def self.add_appointment_feed(lead, appoint, user)
    NewsFeed.create(:user_id=>user.id, :lead_id=>lead.id, :description=>"Meeting - Tour or Signup", :feed_date=>Date.today, :action=>"Start")
  end

end

