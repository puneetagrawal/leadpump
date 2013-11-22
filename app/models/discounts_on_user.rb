class DiscountsOnUser < ActiveRecord::Base
  attr_accessible :discountPercentage, :userRanges
end
