require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.cron '05 07 * * 1-7' do
	AutoResponderRecord.send_auto_respond_mail
end

scheduler.cron '05 02 * * 1-7' do
	AutoResponder.create_charge_for_trail_user
end 


scheduler.every '12h' do
	Lead.get_member_list_from_abc
end

scheduler.cron '13 12 * * 1-7' do
	Company.report
end