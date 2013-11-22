class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  attr_accessible :email, :active, :name, :password, :remember_me, :role_id, :addresses_attributes, :subscription_attributes, :token
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_many :addresses, :dependent => :destroy
  has_one :subscription
  has_many :leads, :dependent => :destroy
  has_many :vipLeads, :dependent => :destroy
  has_many :gmailFriends, :dependent => :destroy
  has_many :authentications , :dependent => :destroy
  has_many :referrals, :dependent => :destroy
  has_many :tweet_referrals, :dependent => :destroy
  has_many :send_invitation_to_gmail_friends, :dependent => :destroy
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
        users = User.where("id != ?", current_user.id)     
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

def checkLeadLimit
  allow = true
  case self.user_role.role_type.to_sym
  when :admin
    allow = false
  else
    limit = self.subscription.plan_per_user_range.plan.lead_management
    if User.numeric?limit
      usrLeads = UserLeads.where(:user_id=>self.id)
      if usrLeads.present? && usrLeads.size() == limit.to_i
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
    users = Company.where(:company_admin_id => self.id)
    if users.present? && users.size() == limit.to_i
      allow = false
    end
  end
  return allow
end

def self.numeric?(object)
  true if Float(object) rescue false
end

  protected

  def generate_token
    random_token = SecureRandom.urlsafe_base64(nil, false)
    self.token = random_token
  end


end
