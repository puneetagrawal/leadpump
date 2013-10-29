class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_create :define_role

  attr_accessible :email, :name, :password, :remember_me, :role_id, :employees_attributes, :locationType, :planType, :discountOnUsers, :addresses_attributes, :subscriptions_attributes
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_many :addresses, :dependent => :destroy
  has_many :subscriptions, :dependent => :destroy
  has_many :employees, :dependent => :destroy
  has_one :role
  accepts_nested_attributes_for :addresses, :subscriptions

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :title, :body

  def define_role
   if(self.subscriptions)
      self.role_id = Role.find_by_role_type("company").id
  else
    self.role_id = Role.find_by_role_type("companyUser").id
  end

end


def self.calculate_total_amount(plan, du, dl, dp)
 @plan = plan ? Plan.find(plan) : nil
  	#discountOnUsers = du != '' ? DiscountsOnUser.find(du).discountPercentage : 0
  	no_of_users = du != '' ? du.to_i : 1
  	dl = dl!= '' ? dl.to_i : 1
  	charges = 0
  	chargess = 0
  	locationCharge = 0
  	@discountOnLocation = nil
  	if @plan.name == 'Basic'
  		i = 1
  	elsif @plan.name == 'Advanced'
  		i = 2
   elsif @plan.name == 'Proffessional'
    i = 3
  elsif @plan.name == 'Proffessional Plus'
    i = 4
  end	
  if(dl <= 10)
    @discountOnLocation = dl != '' ? DiscountsOnLocation.find(1) : nil  		
  elsif (dl > 10 && dl <= 20)
    @discountOnLocation = dl != '' ? DiscountsOnLocation.find(2) : nil
  elsif (dl > 20 && dl <= 50)
    @discountOnLocation = dl != '' ? DiscountsOnLocation.find(3) : nil
  elsif (dl > 50 && dl <= 100)
    @discountOnLocation = dl != '' ? DiscountsOnLocation.find(4) : nil
  end
  chargess = @discountOnLocation ? @discountOnLocation.chargePerUser.split(",") : []
  charges = chargess ? chargess[i] : 0
  locationCharge = chargess ? chargess[0] : 0
  locationCharge = locationCharge * dl
  charges = no_of_users * charges.to_i
  total_charge = locationCharge.to_i + charges.to_i
  discountOnLocations = @discountOnLocation ? @discountOnLocation.discountPercentage : 0
  discountonPeriod = dp != '' ? DiscountsOnPeriod.find(dp).discountPercentage : 0
  amount = ((discountOnLocations + discountonPeriod) * total_charge)/100
  amount = total_charge - amount
  amount = amount * 100
  return amount
end

end
