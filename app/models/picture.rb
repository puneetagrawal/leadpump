class Picture < ActiveRecord::Base
  attr_accessible :avatar, :user_id
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  belongs_to :user
end