# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

DiscountsOnLocation.create(locationRanges: '1-10', discountPercentage: 5, chargePerUser:"51,21,31,51,81")
DiscountsOnLocation.create(locationRanges: '11-20', discountPercentage: 10, chargePerUser:"47,17,27,47,77")
DiscountsOnLocation.create(locationRanges: '21-50', discountPercentage: 15, chargePerUser:"41,11,21,41,71")
DiscountsOnLocation.create(locationRanges: '51-100', discountPercentage: 20, chargePerUser:"37,7,17,37,67")


DiscountsOnPeriod.create(periodType:'monthly', discountPercentage:0)
DiscountsOnPeriod.create(periodType:'yearly', discountPercentage:10)

Plan.create(name:"Basic",price:21, user_position:"Contact Manager", number_of_user:20, lead_management:"250",apportunity_dashboard:true,team_management:false,daily_sales_report:false,daily_sales_projection:false,full_dashboard_enabled:false,traditional_refferals:false,leadpump_social_inviter:false,socail_refferals:"",online_mall:false,daily_team_usage_report:false,unlimited_team_training:false,unlimited_support:false,national_spokeswoman:false)
Plan.create(name:"Advanced",price:31, user_position:"Manage a team-track sales", number_of_user:20, lead_management:"250",apportunity_dashboard:true,team_management:true,daily_sales_report:true,daily_sales_projection:true,full_dashboard_enabled:false,traditional_refferals:false,leadpump_social_inviter:false,socail_refferals:"",online_mall:false,daily_team_usage_report:false,unlimited_team_training:false,unlimited_support:false,national_spokeswoman:false)
Plan.create(name:"Proffessional",price:51, user_position:"Generate Maximum Refferals", number_of_user:20, lead_management:"unlimited",apportunity_dashboard:true,team_management:true,daily_sales_report:true,daily_sales_projection:true,full_dashboard_enabled:true,traditional_refferals:true,leadpump_social_inviter:true,socail_refferals:"unlimited",online_mall:true,daily_team_usage_report:true,unlimited_team_training:false,unlimited_support:false,national_spokeswoman:false)
Plan.create(name:"Proffessional Plus",price:81, user_position:"National Spokeswoman included", number_of_user:20, lead_management:"unlimited",apportunity_dashboard:true,team_management:true,daily_sales_report:true,daily_sales_projection:true,full_dashboard_enabled:true,traditional_refferals:true,leadpump_social_inviter:true,socail_refferals:"unlimited",online_mall:true,daily_team_usage_report:true,unlimited_team_training:true,unlimited_support:true,national_spokeswoman:true)	