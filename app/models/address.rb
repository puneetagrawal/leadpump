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
      if user.isCompany
        user.company_name = company_name
        user.save
      end
	end

  def self.save_address(user, params)
    address = Address.where(user_id: "#{user.id}").last
    if params[:billing_address1].present?
      address.update_attributes(params[:address])
    end
    return address
  end

end

