# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131113170653) do

  create_table "addresses", :force => true do |t|
    t.string   "address"
    t.string   "city"
    t.string   "zip"
    t.string   "state"
    t.string   "phone"
    t.string   "country"
    t.string   "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "appointments", :force => true do |t|
    t.string   "name"
    t.integer  "phone"
    t.string   "email"
    t.string   "notes"
    t.string   "dues"
    t.integer  "enrol"
    t.string   "app_source"
    t.string   "app_time"
    t.date     "app_date"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "employee_id"
  end

  create_table "companies", :force => true do |t|
    t.integer  "company_user_id"
    t.integer  "company_admin_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "discounts_on_locations", :force => true do |t|
    t.string   "locationRanges"
    t.integer  "discountPercentage"
    t.string   "chargePerUser"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "discounts_on_periods", :force => true do |t|
    t.string   "periodType"
    t.integer  "discountPercentage"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "discounts_on_users", :force => true do |t|
    t.string   "userRanges"
    t.integer  "discountPercentage"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "gmail_friends", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "phone"
    t.boolean  "active",       :default => false
    t.string   "secret_token"
    t.integer  "user_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "leads", :force => true do |t|
    t.boolean  "active",                         :default => true
    t.string   "name"
    t.string   "email"
    t.string   "address"
    t.integer  "phone",             :limit => 8
    t.string   "refferred_by"
    t.boolean  "guest_pass_issued"
    t.string   "lead_source"
    t.string   "dues_value"
    t.string   "enrolment_value"
    t.string   "notes"
    t.integer  "company_id"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.string   "goal"
    t.string   "lname"
  end

  create_table "plan_per_user_ranges", :force => true do |t|
    t.integer  "plan_id"
    t.integer  "user_range_id"
    t.integer  "price"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.decimal  "price"
    t.string   "user_position"
    t.integer  "number_of_user"
    t.string   "lead_management"
    t.string   "appointment_sheduler"
    t.boolean  "lead_dashboard"
    t.boolean  "team_management"
    t.boolean  "daily_sales_report"
    t.boolean  "daily_sales_projection"
    t.boolean  "full_dashboard_enabled"
    t.boolean  "traditional_referrals"
    t.boolean  "leadpump_social_inviter"
    t.string   "social_referrals"
    t.boolean  "online_mall"
    t.boolean  "daily_team_usage_report"
    t.boolean  "unlimited_team_training"
    t.boolean  "online_membership"
    t.boolean  "national_spokeswoman"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "role_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "plan_per_user_range_id"
    t.string   "stripe_card_token"
    t.integer  "customer_id"
    t.integer  "user_id"
    t.integer  "locations_count"
    t.integer  "users_count"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "user_leads", :force => true do |t|
    t.integer  "user_id"
    t.integer  "lead_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_ranges", :force => true do |t|
    t.integer  "start_range"
    t.integer  "end_range"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",                   :default => "",   :null => false
    t.string   "email",                  :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,    :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "active",                 :default => true
    t.integer  "role_id"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "vip_leads", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "phone",      :limit => 8
    t.integer  "user_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "email"
    t.boolean  "active",                  :default => false
  end

end
