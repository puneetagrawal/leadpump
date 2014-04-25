class NewsFeed < ActiveRecord::Base
  attr_accessible :action, :description, :feed_date, :user_id, :lead_id

  belongs_to :user
  belongs_to :lead

  def self.get_today_news(user)
    feeds = NewsFeed.includes(:lead).where("leads.id IS NOT NULL").where(:user_id=>user.id, :feed_date=>Date.today).where('action = ? or action = ?',"Start", "Finish")
    return feeds
  end

  def self.get_backlogs(user)
    feeds = NewsFeed.includes(:lead).where("leads.id IS NOT NULL and user_id = ? and feed_date < ? and (action = ? or action = ?)",user.id, Date.today, "Start", "Finish")
    logger.debug(feeds.size)
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
    if feed.save
      logger.debug(">>>>>>>>>>>>>>")
    else
      logger.debug(feed.errors.full_messages)
    end
  end

  def color
    return  self.action == "Start" ? "red" : "green"
  end

end

