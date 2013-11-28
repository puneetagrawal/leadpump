class Picture < ActiveRecord::Base
  attr_accessible :avatar, :user_id
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  belongs_to :user


def self.fetchCompanyLogo(userId)
	company = User.find(userId)
	case company.user_role.role_type.to_sym
	when :employee
		companyId = Company.find_by_company_user_id(company.id)
		company = User.find_by_id(companyId.company_admin_id)
	end
	picture = Picture.find_by_user_id(company.id)
end	


end