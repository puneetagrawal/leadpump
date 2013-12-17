class VipLead < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :phone, :email, :user_id, :active, :status
  belongs_to :user
  before_create :saveStatus

  def self.fetchList(userId)
  	user = User.find(userId)
  	company = Company.find_by_company_user_id(userId)
  	if company.present?
	    allUsers = Company.where(:company_admin_id=>company.company_admin_id).pluck(:company_user_id) 
	    vipleads = UserLeads.includes(:lead).where("leads.lead_source = ?","vip").where(:user_id => allUsers)
  	else
  		vipleads = UserLeads.includes(:lead).where("leads.lead_source = ?","vip").where(:user_id => user.id)
  	end
  	case user.user_role.role_type.to_sym  
    when :admin
      vipleads = UserLeads.includes(:lead).where("leads.lead_source = ?","vip")  
    when :normalUser
    	vipleads = []
	  end   
  	return vipleads
  end

  def self.fetchTemp(user)
    company = user.fetchCompany
    landpage = LandingPage.find_by_user_id(company.id)
    return landpage
  end

  def self.saveLead(viplead, user)
    viplead.save
    user_lead = UserLeads.create(:user_id => user.id, :lead_id => viplead.id)
    user.saveLeadCount
  end

  def self.fetchgmaillink(token,sec_token, user)
    company = user.fetchCompany
    landing = LandingPage.find_by_user_id(user.id)
    if landing.present? && landing.land_type == "External landing page"
      url = parselink(landing.ext_link)
    else
      url = "http://"+SERVER_URL+"/acceptInvitation?token=#{token}&sec=#{sec_token}&source=gmail" 
    end
    return url
  end

  def self.fetchfblink(token, user)
    company = user.fetchCompany
    landing = LandingPage.find_by_user_id(user.id)
    if landing.present? && landing.land_type == "External landing page"
      url = parselink(landing.ext_link)
    else
      url = "http://"+SERVER_URL+"/acceptInvitation?token=#{token}&source=fb" 
    end
    return url
  end

  def self.parselink(link)
    begin
        uri = URI.parse(link)
        resp = uri.kind_of?(URI::HTTP)
      rescue URI::InvalidURIError
        resp = false
        link = "http://#{link}"
      end
      return link
  end

  protected

  def saveStatus
	  self.status = "dead"
  end
end
