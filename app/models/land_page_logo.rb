class LandPageLogo < ActiveRecord::Base
  attr_accessible :landing_page_id, :avatar
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  
  belongs_to :landing_page
end
