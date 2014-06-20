class Address < ActiveRecord::Base
	belongs_to :user
	attr_accessible :address, :city, :zip, :state, :phone, :country, :user_id
	def self.save_user(address, company_name, user)
	  add = Address.find_by_user_id("#{user.id}")
      if add.present?
        add.update_attributes(address)
      else
        add = Address.new(address)
        add.user_id = "#{user.id}"
        add.save
      end
      logger.debug(":DSFSDFDSF")
      logger.debug(add.id)
      if user.isCompany
        logger.debug("inside")
        user.company_name = company_name
        user.save
      end
	end
end
