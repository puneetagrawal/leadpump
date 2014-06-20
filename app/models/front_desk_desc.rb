class FrontDeskDesc < ActiveRecord::Base
  attr_accessible :description, :user_id, :title

  translates :description
  
  belongs_to :user
end
