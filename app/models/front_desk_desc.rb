class FrontDeskDesc < ActiveRecord::Base
  attr_accessible :description, :user_id, :title

  belongs_to :user
end
