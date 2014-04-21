require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '05 02 * * 1-7' do
	AutoResponderRecord.send_auto_respond_mail
end


scheduler.cron '05 04 * * 1-7' do
	AutoResponder.create_charge_for_trail_user
end
