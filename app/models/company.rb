class Company < ActiveRecord::Base
   attr_accessible :company_admin_id, :company_user_id
   belongs_to :user


   def self.checkuserstatus(userId)
		user = User.find(userId)
		status = "Inactive"
		if user.present?
			status = user.active ? "Active" : "Inactive"
		end
	end
end
