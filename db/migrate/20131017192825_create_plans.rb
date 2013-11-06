class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string  :name
      t.decimal :price
      t.string  :user_position
      t.integer :number_of_user
      t.string  :lead_management
      t.string  :appointment_sheduler
      t.boolean :lead_dashboard
      t.boolean :team_management
      t.boolean :daily_sales_report
      t.boolean :daily_sales_projection
      t.boolean :full_dashboard_enabled
      t.boolean :traditional_referrals
      t.boolean :leadpump_social_inviter
      t.string  :social_referrals
      t.boolean :online_mall
      t.boolean :daily_team_usage_report
      t.boolean :unlimited_team_training
      t.boolean :online_membership
      t.boolean :national_spokeswoman

      t.timestamps
    end
  end
end