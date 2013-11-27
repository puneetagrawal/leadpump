

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  attr_accessible :email,:users_created, :leads_created, :active, :name, :password, :remember_me, :role_id, :addresses_attributes, :subscription_attributes, :token
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_many :addresses, :dependent => :destroy
  has_one :subscription
  has_one :picture, :dependent => :destroy
  has_many :leads, :dependent => :destroy
  has_many :vipLeads, :dependent => :destroy
  has_many :gmailFriends, :dependent => :destroy
  has_many :authentications , :dependent => :destroy
  has_many :referrals, :dependent => :destroy
  has_many :tweet_referrals, :dependent => :destroy
  has_many :send_invitation_to_gmail_friends, :dependent => :destroy
  has_many :opt_in_leads, :dependent => :destroy
  belongs_to :role
  accepts_nested_attributes_for :addresses, :subscription

  after_create :generate_token

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

  def self.fetchCompanyUserList(user)
    users = []
    case user.user_role.role_type.to_sym  
      when :admin
        users = User.where("id != ?", user.id)     
      when :company
        users = Company.where(:company_admin_id => user.id).pluck(:company_user_id)
        users = users.collect{|user| User.find(user)}
    end
  end

  def getCompanyEmail
    email = self.email
    case self.user_role.role_type.to_sym
    when :employee
      companyId = Company.find_by_company_user_id(self.id)
      user = User.find_by_id(companyId)
      email = user.email
    end
    return email
  end

  def fetchCompanyName
    name = self.name
    case self.user_role.role_type.to_sym
    when :employee
      companyId = Company.find_by_company_user_id(self.id)
      user = companyId.present? ? User.find_by_id(companyId.company_admin_id) : nil
      name = user.present? ? user.name : ''
    end
    return name.humanize
  end

  def fetchCompanyId
    id = self.id
    case self.user_role.role_type.to_sym
    when :employee
      companyId = Company.find_by_company_user_id(self.id)
      user = User.find_by_id(companyId)
      id = user.id
    end
    return id
  end

def saveLeadCount
  company = self.fetchCompanyId
  user = User.find(company)
  if user.present?
    user.update_attributes(:leads_created=>user.leads_created+1)
  end
end

def checkLeadLimit
  allow = true
  case self.user_role.role_type.to_sym
  when :admin
    allow = false
  else
    limit = self.no_of_users
    if User.numeric?limit
      usrLeads = UserLeads.where(:user_id=>self.id)
      if self.leads_created == limit.to_i
        allow = false
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
    limit = self.subscription.plan_per_user_range.plan.number_of_user
    if self.users_created == limit.to_i
      allow = false
    end
  end
  return allow
end

def self.numeric?(object)
  true if Float(object) rescue false
end

def self.fetchUserByPlan(plan)
  plan = Plan.where("name ilike ? ",plan).pluck(:id)
  logger.debug(plan)
  planperuserrange = PlanPerUserRange.where(:plan_id=> plan).pluck(:id)
  subscription = Subscription.includes(:user).where(:plan_per_user_range_id=>planperuserrange)
  return users
end

def fetchEmailMessage
  company = self.fetchCompanyId
  message = 'I just joined "gym", here a free 7-day pass for you.Come join me!'
  socialmessage = SocialMessage.find_by_company_id(company)
  if socialmessage.gmailMessage.present?
    message = socialmessage.gmailMessage
  end
  return message
end

def fetchFacebookMessage
  company = self.fetchCompanyId
  message = 'I just joined "gym", here a free 7-day pass for you.Come join me!'
  socialmessage = SocialMessage.find_by_company_id(company)
  if socialmessage.facebookMessage.present?
    message = socialmessage.facebookMessage
  end
  return message
end

def fetchtwitterMessage
  company = self.fetchCompanyId
  message = 'I just joined "gym", here a free 7-day pass for you.Come join me!'
  socialmessage = SocialMessage.find_by_company_id(company)
  if socialmessage.twitterMessage.present?
    message = socialmessage.twitterMessage
  end
  return message
end

  protected

  def generate_token
    token = SecureRandom.urlsafe_base64(self.id, false)
    self.token = token
    self.save
  end


end
