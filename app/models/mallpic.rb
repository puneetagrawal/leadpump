class Mallpic < ActiveRecord::Base
  attr_accessible :onlinemall_id, :avatar

  has_attached_file :avatar, :styles => { :medium => "100x100>", :thumb => "30x30>" }, :default_url => "/images/:style/missing.png"
  belongs_to :onlinemall
end
