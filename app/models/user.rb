
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  include ApplicationHelper
  attr_accessible :email,:users_created, :leads_created, :active, :name, :password, :remember_me, 
  :role_id, :addresses_attributes, :subscription_attributes, :token, :reset_status, :vipon, :vipcount,
  :associate
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_many :addresses
  has_many :vipLeads
  has_many :gmailFriends
  has_many :authentications 
  has_many :referrals
  has_many :tweet_referrals
  has_many :send_invitation_to_gmail_friends
  has_many :opt_in_leads
  has_many :statss
  has_many :onlinemalls
  has_many :saleProds
  has_one  :landing_page
  belongs_to :role
  has_one :subscription
  has_one :picture
  accepts_nested_attributes_for :addresses, :subscription

  validates :name, :presence => true

  after_create :generate_token,:saveVipsetings

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :title, :body


# def user_role
#   return self.role.role_type
# end

 # Role.all.each do |r| 
 #    define_method "#{r.role_type}?" do
 #        user_role == r.role_type     
 #    end
 #  end

  def user_role
    Role.where(:id => self.role_id).last
  end

  def role?(base_role)   
    if user_role.blank? or user_role.name.try(:humanize) != base_role.to_s.try(:humanize)
       false
    else 
       true
    end   
  end

  def isAdmin
    isadmin = self.user_role.id == 1 ? true : false
    return isadmin
  end

  def isCompany
    iscompany = self.user_role.id == 2 ? true : false
    logger.debug(iscompany)
    return iscompany
  end

  def isEmployee
    isemployee = self.user_role.id == 3 ? true : false
    return isemployee
  end

  def isNormaluser
    isNormaluser = self.user_role.id == 4 ? true : false
    return isNormaluser
  end

  def isSocialInvitable
    company = self.fetchCompany
    allow = false
    if company.subscription.present? && !company.subscription.plan_per_user_range.plan.social_referrals.blank?
        allow = true
    end
  end

  def self.calculate_total_amount(plan, du, dl, dp)
    @amount = signUpAmount(planId, du, dl, dp)
    amounts = @amount.amount * 100
    return amounts
  end

  def self.signUpAmount(planId, du, dp)
      @plan = planId ? PlanPerUserRange.find(planId) : nil
      no_of_users = du.to_i

      totalCharge = @plan.price * no_of_users
      chargesPerUserStr = "$#{@plan.price} * #{no_of_users} = $#{totalCharge} per month"
      disAmount = 0
      disAmountStr = "No Discount"
      paymentPeriod = '/month'
      if dp == 'yearly'
        totalCharge = totalCharge * 12
        disAmount =  (totalCharge * 17)/100
        disAmountStr = "$ #{disAmount} on yearly"
        paymentPeriod = "/year"
      end
      amount = totalCharge - disAmount
      amountStr = "$ #{amount}" + paymentPeriod
      @msg = { "chargesPerUserStr" => chargesPerUserStr, "disAmountStr" => disAmountStr, "amountStr" => amountStr, "amount" => amount}
      return @msg
  end

  def fetchCompanySalesUsers
    users = []
    case self.user_role.role_type.to_sym  
      when :admin
        users = User.where("id != ?", self.id)
      when :company
        company = Company.where(:company_admin_id=>self.id).pluck(:company_user_id)
        users = User.where(:id=> company)
      end
      return users
  end

  def self.fetchCompanyUserList(user)
    users = []
    case user.user_role.role_type.to_sym  
      when :admin
        users = User.where("id != ?", user.id)     
      when :company
        users = Company.where(:company_admin_id => user.id).pluck(:company_user_id)
        users = users.collect{|user| User.find(user)}
      when :employee
        users << user
    end
  end

  def self.deleteusersfromcompany(companyusers)
    users = Company.where(:company_user_id=>companyusers)
    if users.present?
      users.each do|company|
        #company.destroy
      end
    end
  end

  def getCompanyEmail
    email = self.email
    case self.user_role.role_type.to_sym
    when :employee
      companyId = Company.find_by_company_user_id(self.id)
      user = User.find_by_id(companyId)
      if user.present?
        email = user.email
      end
    end
    return email
  end

  # def fetchCompanyName
  #   name = self.name
  #   case self.user_role.role_type.to_sym
  #   when :employee
  #     companyId = Company.find_by_company_user_id(self.id)
  #     user = companyId.present? ? User.find_by_id(companyId.company_admin_id) : nil
  #     name = user.present? ? user.name : ''
  #   end
  #   return name.humanize
  # end

  # def fetchCompanyId
  #   id = self.id
  #   case self.user_role.role_type.to_sym
  #   when :employee
  #     companyId = Company.find_by_company_user_id(self.id)
  #     user = User.find_by_id(companyId)
  #     id = user.id
  #   end
  #   return id
  # end

  def self.fetchPaidUser
    subscription = Subscription.where("payment IS NOT NULL")
  end

  def fetchPlan
    plan = nil
    company = self.fetchCompany
    if company.present? && company.subscription.present? 
      plan = company.subscription.plan_per_user_range.plan
    end
    
    return plan
  end

  def fetchPlanName  
    plan = self.fetchPlan
    return plan.present? ? plan.name : ''
  end

  def fetchCompany
    company = self
    case self.user_role.role_type.to_sym
    when :employee
      companyId = Company.find_by_company_user_id(self.id)
      company = User.find_by_id(companyId.company_admin_id)
    end
    return company
  end

  def fetchcompanymallitem
    company = self.fetchCompany
    mallitems = Companymallitem.where(:user_id=>company.id)
    return mallitems
  end
  
def saveLeadCount
  user = self.fetchCompany
  if user.present?
    user.update_attributes(:leads_created=>user.leads_created+1)
  end
end

def checkLeadLimit
  allow = false
  case self.user_role.role_type.to_sym
  when :admin
    allow = false
  when :employee
    user = self.fetchCompany
    limit = user.subscription.plan_per_user_range.plan.lead_management
    if check_plan_expired(user)
      if !User.numeric?limit || user.leads_created <= limit.to_i
        allow = true
      end
    end
  when :company
    limit = self.subscription.plan_per_user_range.plan.lead_management
    if check_plan_expired(self)
      if self.leads_created <= limit.to_i || limit == "unlimited"
        allow = true
      end
    end
  end
  return allow
end

def checkUserLimit
  allow = true
  case self.user_role.role_type.to_sym
  when :admin
    allow = false
  else
    limit = self.subscription.present? ? self.subscription.users_count.present? ? self.subscription.users_count : 10 : 10
    if self.users_created >= limit && check_plan_expired(self)
      allow = false
    end
  end
  return allow
end

def self.numeric?(object)
  true if Float(object) rescue false
end

def self.fetchUserByPlan(plan)
  planperuserrange = PlanPerUserRange.where(:plan_id=> plan).pluck(:id)
  subscription = Subscription.includes(:user).where(:plan_per_user_range_id=>planperuserrange).pluck(:user_id)
  companyUsers = Company.where(:company_admin_id=>subscription).pluck(:company_user_id)
  subscription.push(companyUsers.flatten!)
  users = subscription.present? ? subscription.collect{|user| find_user(user) }.compact : []
  return users
end

def fetchfbsubject
  company = self.fetchCompany
  message = "An Inviation from #{self.name.humanize} to you. "
  socialmessage = SocialMessage.find_by_company_id(company.id)
  if socialmessage.present? && socialmessage.fbsubject.present?
     message = socialmessage.fbsubject
  end
  return message.html_safe
end

def fetchgmailsubject
  company = self.fetchCompany
  message = "An Inviation from #{self.name.humanize} to you."
  socialmessage = SocialMessage.find_by_company_id(company.id)
  if socialmessage.present? && socialmessage.gmailsubject.present?
    message = socialmessage.gmailsubject
  end
  return message.html_safe
end

def fetchEmailMessage
  company = self.fetchCompany
  message = 'I just joined "gym", here a free 7-day pass for you.Come join me!'
  socialmessage = SocialMessage.find_by_company_id(company.id)
  if socialmessage.present? && socialmessage.gmailMessage.present?
    message = socialmessage.gmailMessage
  end
  return message.html_safe
end

def fetchFacebookMessage
  company = self.fetchCompany
  message = 'I just joined "gym", here a free 7-day pass for you.Come join me!'
  socialmessage = SocialMessage.find_by_company_id(company.id)
  if socialmessage.present? && socialmessage.facebookMessage.present?
    message = socialmessage.facebookMessage
  end
  return message.html_safe
end

def fetchtwitterMessage
  company = self.fetchCompany
  message = 'I just joined "gym", here a free 7-day pass for you.Come join me!'
  socialmessage = SocialMessage.find_by_company_id(company.id)
  if socialmessage.present? && socialmessage.twitterMessage.present?
    message = socialmessage.twitterMessage
  end
  return message.html_safe
end

def self.find_user(id)
  logger.debug(id)
    begin
      return User.find(id)
    rescue
    end
  end
  protected

  def generate_token
    token = SecureRandom.urlsafe_base64(self.id, false)
    self.token = token[0, 10]

  end

  def saveVipsetings
    self.vipcount = 3
    self.vipon = true
    self.save
  end

end#main
