require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.at "00:30:00" do
	User.create_charge_for_trail_user
end
scheduler.at "08:45:00" do
	AutoResponderRecord.send_auto_respond_mail
end
