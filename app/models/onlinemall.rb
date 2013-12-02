class Onlinemall < ActiveRecord::Base
  attr_accessible :active, :link, :mallpic_id, :title, :user_id

  has_many :mallpic
  belongs_to :user

  accepts_nested_attributes_for :mallpic

  validates :title, :presence => true
  validates :link, :presence => true
end
