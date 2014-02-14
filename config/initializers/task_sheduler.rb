require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.at "13:50:00" do
	User.create_charge_for_trail_user
end