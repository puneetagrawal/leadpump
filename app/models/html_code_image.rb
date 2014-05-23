class HtmlCodeImage < ActiveRecord::Base
  attr_accessible :avatar, :user_id
  has_attached_file :avatar, :styles => { :meduim=>"220x250" }, :default_url => "/images/:style/missing.png"

  belongs_to :user
end
