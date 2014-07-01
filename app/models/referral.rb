class Referral < ActiveRecord::Base
  attr_accessible :email, :name, :referrer

  belongs_to :user

  # validates :email, :uniqueness => true
  # validates :referrer, :uniqueness => true

  # before_save :check_email

  def check_email
  	email = Referral.where(:email=>self.email, :referrer=>self.referrer)
 	  if email.present?
	  	raise "You are already registered..!!"
	  end
  end

end
