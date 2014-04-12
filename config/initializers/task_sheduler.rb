require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.at "00:05:00" do
	AutoResponderRecord.send_auto_respond_mail
end


scheduler.at "01:30:00" do
	AutoResponder.create_charge_for_trail_user
end
