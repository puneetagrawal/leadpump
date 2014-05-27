class FrontDeskDesc < ActiveRecord::Base
  attr_accessible :description, :user_id, :title

  translates :description, :title

  belongs_to :user
end
