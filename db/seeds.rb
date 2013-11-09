# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(name:"admin", email:"admin@lead.com", password:"admin123",role_id:1)
User.create(name:"company", email:"company@lead.com", password:"company123",role_id:2)
User.create(name:"companyUser", email:"companyUser@lead.com", password:"companyUser123",role_id:3)

DiscountsOnLocation.create(locationRanges: '1-10', discountPercentage: 5, chargePerUser:"21,31,51,81")
DiscountsOnLocation.create(locationRanges: '11-20', discountPercentage: 10, chargePerUser:"17,27,47,77")
DiscountsOnLocation.create(locationRanges: '21-50', discountPercentage: 15, chargePerUser:"11,21,41,71")
DiscountsOnLocation.create(locationRanges: '51-100', discountPercentage: 20, chargePerUser:"7,17,37,67")
DiscountsOnLocation.create(locationRanges: '101-200', discountPercentage: 20, chargePerUser:"5,15,35,65")


DiscountsOnPeriod.create(periodType:'monthly', discountPercentage:0)
DiscountsOnPeriod.create(periodType:'yearly', discountPercentage:17)

Plan.create(name:"Basic",price:21, user_position:"Contact Manager", number_of_user:10, lead_management:"500",appointment_sheduler:"unlimited",lead_dashboard:true,team_management:false,daily_sales_report:false,daily_sales_projection:false,full_dashboard_enabled:false,traditional_referrals:false,leadpump_social_inviter:false,social_referrals:"",online_mall:false,daily_team_usage_report:false,unlimited_team_training:false,national_spokeswoman:false,online_membership:false)
Plan.create(name:"Advanced",price:31, user_position:"Manage a team-track sales", number_of_user:10, lead_management:"100",appointment_sheduler:"unlimited",lead_dashboard:true,team_management:true,daily_sales_report:true,daily_sales_projection:true,full_dashboard_enabled:true,traditional_referrals:true,leadpump_social_inviter:false,social_referrals:"",online_mall:false,daily_team_usage_report:false,unlimited_team_training:false,national_spokeswoman:false,online_membership:false)
Plan.create(name:"Professional",price:51, user_position:"Generate Maximum Refferals", number_of_user:10, lead_management:"unlimited",appointment_sheduler:"unlimited",lead_dashboard:true,team_management:true,daily_sales_report:true,daily_sales_projection:true,full_dashboard_enabled:true,traditional_referrals:true,leadpump_social_inviter:true,social_referrals:"unlimited",online_mall:true,daily_team_usage_report:true,unlimited_team_training:false,national_spokeswoman:false,online_membership:false)
Plan.create(name:"Professional Plus",price:81, user_position:"National Spokeswoman included", number_of_user:10, lead_management:"unlimited",appointment_sheduler:"unlimited",lead_dashboard:true,team_management:true,daily_sales_report:true,daily_sales_projection:true,full_dashboard_enabled:true,traditional_referrals:true,leadpump_social_inviter:true,social_referrals:"unlimited",online_mall:true,daily_team_usage_report:true,unlimited_team_training:true,national_spokeswoman:true,online_membership:true)	

UserRange.create(start_range:1, end_range:10)
UserRange.create(start_range:11, end_range:20)
UserRange.create(start_range:21, end_range:50)
UserRange.create(start_range:51, end_range:100)
UserRange.create(start_range:101, end_range:200)

PlanPerUserRange.create(plan_id:1,price:5,user_range_id:5)
PlanPerUserRange.create(plan_id:2,price:15,user_range_id:5)
PlanPerUserRange.create(plan_id:3,price:35,user_range_id:5)
PlanPerUserRange.create(plan_id:4,price:65,user_range_id:5)

PlanPerUserRange.create(plan_id:1,price:7,user_range_id:4)
PlanPerUserRange.create(plan_id:2,price:17,user_range_id:4)
PlanPerUserRange.create(plan_id:3,price:37,user_range_id:4)
PlanPerUserRange.create(plan_id:4,price:67,user_range_id:4)

PlanPerUserRange.create(plan_id:1,price:11,user_range_id:3)
PlanPerUserRange.create(plan_id:2,price:21,user_range_id:3)
PlanPerUserRange.create(plan_id:3,price:41,user_range_id:3)
PlanPerUserRange.create(plan_id:4,price:71,user_range_id:3)

PlanPerUserRange.create(plan_id:1,price:17,user_range_id:2)
PlanPerUserRange.create(plan_id:2,price:27,user_range_id:2)
PlanPerUserRange.create(plan_id:3,price:47,user_range_id:2)
PlanPerUserRange.create(plan_id:4,price:77,user_range_id:2)

PlanPerUserRange.create(plan_id:1,price:21,user_range_id:1)
PlanPerUserRange.create(plan_id:2,price:31,user_range_id:1)
PlanPerUserRange.create(plan_id:3,price:51,user_range_id:1)
PlanPerUserRange.create(plan_id:4,price:81,user_range_id:1)

Role.create(role_type:"admin")
Role.create(role_type:"company")
Role.create(role_type:"employee")
Role.create(role_type:"normalUser")