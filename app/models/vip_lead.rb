class VipLead < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :phone, :email, :user_id, :active, :status
  belongs_to :user
  before_create :saveStatus

  def self.fetchList(userId)
  	user = User.find(userId)
  	company = Company.find_by_company_user_id(userId)
  	if company.present?
	    allUsers = Company.where(:company_admin_id=>company.company_admin_id).pluck(:company_user_id) 
	    vipleads = UserLeads.includes(:lead).where(:user_id => allUsers)
  	else
  		vipleads = UserLeads.includes(:lead).where(:user_id => user.id)
  	end
  	case user.user_role.role_type.to_sym  
    when :admin
      vipleads = VipLead.all   
    when :normalUser
    	vipleads = []
	  end   
  	return vipleads
  end

  protected

  def saveStatus
	  self.status = "dead"
  end
end
