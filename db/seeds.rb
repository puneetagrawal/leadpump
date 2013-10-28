# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

(1..5).each_with_index do |val, i|
	Plan.create(name: 'plan#{i+1}', price:"340")
end

(1..5).each_with_index do |val, i|
	j = j > 4 ? j : i
	DiscountsOnLocation.create(discountPercentage: j+5, locationRanges:"1-5")
	j += 5
end


(1..5).each_with_index do |val, i|
	j = j > 4 ? j : i
	DiscountsOnUser.create(discountPercentage: j+5, userRanges:"1-5")
	j += 5
end

DiscountsOnPeriod.create(discountPercentage: 0, periodType:"monthly")
DiscountsOnPeriod.create(discountPercentage: 10, periodType:"yearly")