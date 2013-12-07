class Preview < ActiveRecord::Base
  attr_accessible  :header_text, :intro_text,:mission_text,:header_color,:bg_color,:no_of_days, :avatar
  
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  			
end
