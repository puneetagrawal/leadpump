class LandingPage < ActiveRecord::Base
  attr_accessible :land_type, :temp_name, :header_text, :intro_text,:mission_text,:header_color,:bg_color,:no_of_days,
  			:user_id, :ext_link


  belongs_to :user
  has_many :land_page_logos

  accepts_nested_attributes_for :land_page_logos
end
