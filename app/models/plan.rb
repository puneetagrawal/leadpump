class Plan < ActiveRecord::Base
	has_many :subscriptions

	attr_accessible :name, :price, :user_position, :number_of_user, :lead_management, :apportunity_dashboard,:team_management,:daily_sales_report,
	:daily_sales_projection,:full_dashboard_enabled, :traditional_refferals,:leadpump_social_inviter,:socail_refferals,
	:online_mall, :daily_team_usage_report, :unlimited_team_training, :unlimited_support, :national_spokeswoman 
end