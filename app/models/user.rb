class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  attr_accessible :email, :active, :name, :password, :remember_me, :role_id, :addresses_attributes, :subscription_attributes
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_many :addresses, :dependent => :destroy
  has_one :subscription, :dependent => :destroy
  has_many :leads, :dependent => :destroy
  belongs_to :role
  accepts_nested_attributes_for :addresses, :subscription

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
      users = User.all     
    when :company
      users = Company.where(:company_admin_id => user.id).pluck(:company_user_id)
      users << user.id
      users = users.collect{|user| User.find(user)}
    end
  end
  
end
