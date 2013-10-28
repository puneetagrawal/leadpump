class AddUserPositionToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :user_position, :string
    add_column :plans, :number_of_user, :integer
    add_column :plans, :lead_management, :string
    add_column :plans, :apportunity_dashboard, :boolean
    add_column :plans, :team_management, :boolean
    add_column :plans, :daily_sales_report, :boolean
    add_column :plans, :daily_sales_projection, :boolean
    add_column :plans, :full_dashboard_enabled, :boolean
    add_column :plans, :traditional_refferals, :boolean
    add_column :plans, :leadpump_social_inviter, :boolean
    add_column :plans, :socail_refferals, :string
    add_column :plans, :online_mall, :boolean
    add_column :plans, :daily_team_usage_report, :boolean
    add_column :plans, :unlimited_team_training, :boolean
    add_column :plans, :unlimited_support, :boolean
    add_column :plans, :national_spokeswoman, :boolean
  end
end
