require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.at "00:30:00" do
	User.create_charge_for_trail_user
end