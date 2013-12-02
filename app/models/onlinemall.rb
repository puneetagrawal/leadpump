class Onlinemall < ActiveRecord::Base
  attr_accessible :active, :link, :mallpic_id, :title, :user_id

  has_many :mallpics
  belongs_to :user
end
