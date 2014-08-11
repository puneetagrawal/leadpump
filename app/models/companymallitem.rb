class Companymallitem < ActiveRecord::Base
  attr_accessible :onlinemall_id, :user_id

  belongs_to :onlinemall
  belongs_to :user
end
