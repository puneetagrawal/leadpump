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

ActiveRecord::Schema.define(:version => 20140214113115) do

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
    t.string   "phone"
    t.string   "email"
    t.string   "notes"
    t.string   "dues"
    t.integer  "enrol"
    t.string   "app_source"
    t.string   "app_time"
    t.date     "app_date"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "employee_id"
    t.string   "task"
    t.datetime "app_date_time"
    t.integer  "user_id"
    t.integer  "lead_id"
  end

  create_table "companies", :force => true do |t|
    t.integer  "company_user_id"
    t.integer  "company_admin_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "companymallitems", :force => true do |t|
    t.integer  "onlinemall_id"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
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
    t.string   "email"
    t.string   "name"
    t.integer  "user_id"
    t.boolean  "visited",      :default => false
    t.boolean  "opt_in",       :default => false
    t.boolean  "sent",         :default => false
    t.string   "secret_token"
    t.boolean  "oppened",      :default => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "source"
    t.string   "access_token"
  end

  create_table "land_page_logos", :force => true do |t|
    t.integer  "landing_page_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "landing_pages", :force => true do |t|
    t.string   "land_type"
    t.string   "temp_name"
    t.text     "header_text"
    t.text     "intro_text"
    t.text     "mission_text"
    t.string   "header_color"
    t.string   "bg_color"
    t.string   "no_of_days"
    t.integer  "land_page_logo_id"
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "ext_link"
  end

  create_table "lead_notes", :force => true do |t|
    t.text     "notes"
    t.datetime "time_stam"
    t.integer  "lead_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
    t.string   "status"
    t.integer  "no_of_days"
    t.string   "associate"
  end

  create_table "mallpics", :force => true do |t|
    t.integer  "onlinemall_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "onlinemalls", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.boolean  "active"
    t.integer  "mallpic_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "user_id"
    t.string   "description"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "opt_in_leads", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "phone",       :limit => 8
    t.string   "source"
    t.integer  "referrer_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "pictures", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "viplogo_file_name"
    t.string   "viplogo_content_type"
    t.integer  "viplogo_file_size"
    t.datetime "viplogo_updated_at"
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

  create_table "previews", :force => true do |t|
    t.text     "header_text"
    t.text     "intro_text"
    t.text     "mission_text"
    t.string   "header_color"
    t.string   "bg_color"
    t.string   "no_of_days"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "temp_name"
  end

  create_table "referrals", :force => true do |t|
    t.string   "referrer"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "role_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sale_prods", :force => true do |t|
    t.integer  "call",        :limit => 8
    t.integer  "appointment", :limit => 8
    t.integer  "referral",    :limit => 8
    t.integer  "mail",        :limit => 8
    t.integer  "net",         :limit => 8
    t.integer  "user_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "sale_reports", :force => true do |t|
    t.string   "s_type"
    t.integer  "contract"
    t.integer  "amount"
    t.string   "name"
    t.string   "source"
    t.string   "report"
    t.integer  "mem_no"
    t.integer  "commission"
    t.integer  "sale_prod_id"
    t.integer  "eft"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "cheque"
  end

  create_table "send_ivitation_to_gmail_friends", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "social_messages", :force => true do |t|
    t.text     "facebookMessage"
    t.text     "twitterMessage"
    t.text     "gmailMessage"
    t.integer  "company_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "fbsubject"
    t.string   "gmailsubject"
  end

  create_table "stats", :force => true do |t|
    t.string   "source",      :default => "email"
    t.string   "location",    :default => "Default Location"
    t.integer  "e_sents"
    t.integer  "e_oppened"
    t.integer  "e_views"
    t.integer  "e_converted"
    t.integer  "user_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "plan_per_user_range_id"
    t.string   "stripe_card_token"
    t.integer  "user_id"
    t.integer  "locations_count"
    t.integer  "users_count"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.date     "expiry_date"
    t.string   "plan_type"
    t.integer  "payment"
    t.string   "customer_id"
    t.string   "charge_id"
  end

  create_table "temporary_data", :force => true do |t|
    t.string   "associate"
    t.string   "fn"
    t.string   "add"
    t.string   "zp"
    t.string   "ag"
    t.string   "ct"
    t.string   "em"
    t.string   "ph"
    t.string   "gst"
    t.string   "prg"
    t.string   "st"
    t.string   "cex"
    t.string   "hc"
    t.string   "fg"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tweet_referrals", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "referrer"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
    t.string   "name",                   :default => "",    :null => false
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,     :null => false
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
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "token"
    t.integer  "users_created",          :default => 0
    t.integer  "leads_created",          :default => 0
    t.boolean  "reset_status",           :default => false
    t.boolean  "vipon"
    t.integer  "vipcount"
    t.string   "associate"
    t.boolean  "trial"
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
    t.string   "status"
  end

end
