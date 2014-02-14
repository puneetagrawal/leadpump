require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.in "60s" do
	User.create_charge_for_trail_user
end