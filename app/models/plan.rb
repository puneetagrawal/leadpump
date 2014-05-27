class Plan < ActiveRecord::Base
	has_many :subscriptions
	has_many :planPerUserRanges

	attr_accessible :name, :price, :user_position, :number_of_user, :lead_management,:appointment_sheduler, :lead_dashboard,:team_management,:daily_sales_report,
	:daily_sales_projection,:full_dashboard_enabled, :traditional_referrals,:leadpump_social_inviter,:social_referrals,
	:online_mall, :daily_team_usage_report, :unlimited_team_training, :national_spokeswoman, :online_membership 

	translates :name, :user_position,:lead_management,:appointment_sheduler,:social_referrals

end