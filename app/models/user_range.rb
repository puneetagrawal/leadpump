class UserRange < ActiveRecord::Base
  attr_accessible :end_range, :start_range
  has_many :planPerUserRanges
end
