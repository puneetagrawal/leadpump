class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  attr_accessible :email, :name, :password, :remember_me, :role_id, :addresses_attributes, :subscriptions_attributes
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_many :addresses, :dependent => :destroy
  has_many :subscriptions, :dependent => :destroy
  has_many :leads, :dependent => :destroy
  belongs_to :role
  accepts_nested_attributes_for :addresses, :subscriptions

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


  def self.signUpAmount(planId, du, dl, dp)
    @plan = planId ? Plan.find(planId) : nil
      no_of_users = du.to_i
      dl = dl.to_i

      charges = 0
      chargesList = []
      @discountOnLocation = nil

      i = 0
      if @plan.name == 'Advanced'
        i = 1
      elsif @plan.name == 'Proffessional'
        i = 2
      elsif @plan.name == 'Proffessional Plus'
        i = 3
      end 
      if(no_of_users <= 10)
        @discountOnLocation = DiscountsOnLocation.find(1)       
      elsif (no_of_users > 10 && no_of_users <= 20)
        @discountOnLocation = DiscountsOnLocation.find(2)
      elsif (no_of_users > 20 && no_of_users <= 50)
        @discountOnLocation = DiscountsOnLocation.find(3)
      elsif (no_of_users > 50 && no_of_users <= 100)
        @discountOnLocation = DiscountsOnLocation.find(4)
      else
        @discountOnLocation = DiscountsOnLocation.find(5)
      end

      chargesList = @discountOnLocation ? @discountOnLocation.chargePerUser.split(",") : []
      chargesPerUser = chargesList[i].to_i
      totalCharge = chargesPerUser * no_of_users
      chargesPerUserStr = "$#{chargesPerUser} * #{no_of_users} = $#{totalCharge} per month"
      disAmount = 0
      disAmountStr = "No Discount"
      paymentPeriod = ' per month'
      if dp == 'yearly'
        totalCharge = totalCharge * 12
        disAmount =  (totalCharge * 17)/100
        disAmountStr = "$#{disAmount} on yearly"
        paymentPeriod = " per year"
      end
      amount = totalCharge - disAmount
      amountStr = "$#{amount}" + paymentPeriod
      @msg = { "chargesPerUserStr" => chargesPerUserStr, "disAmountStr" => disAmountStr, "amountStr" => amountStr, "amount" => amount}
      return @msg
  end

end
