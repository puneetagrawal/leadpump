class DiscountsOnLocation < ActiveRecord::Base
  attr_accessible :discountPercentage, :locationRanges, :chargePerUser
end
