class Address < ActiveRecord::Base
	belongs_to :user
	attr_accessible :address, :city, :zip, :state, :phone, :country
end
