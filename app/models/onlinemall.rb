class Onlinemall < ActiveRecord::Base
  attr_accessible :active, :link, :mallpic_id, :title, :user_id

  has_one :mallpics
  belongs_to :user

  accepts_nested_attributes_for :mallpics
end
