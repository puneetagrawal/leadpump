class Lead < ActiveRecord::Base
  attr_accessible :name, :lname, :active, :address, :phone, :email, :address, :refferred_by, :goal, :lead_source, :guest_pass_issued, :dues_value, :enrolment_value, :notes, :user_id, :status, :no_of_days
  belongs_to :user

  validates :name, :presence => true
  validates :email, :presence => true
  validates :lead_source, :presence => true
  validates :lead_source, :presence => true
  validates :email, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}, :if => :email?
  validates :phone, :numericality => {:only_integer => true}, :if => :phone?


# def self.userLeads(user)
# 	leads = []
# 	puts user.user_role.role_type.to_sym
# 	case user.user_role.role_type.to_sym  
#     when :admin
#       leads = UserLeads.includes(:lead).all     
#     when :company
#       userList = Company.where(:company_admin_id => user.id).pluck(:company_user_id)
#       userList << user.id
#       leads = UserLeads.includes(:lead).where(:user_id => @userList)
#       userList = @userList.collect{|user| User.find(user)}
#     when :employee
#       leads = UserLeads.includes(:lead).where(:user_id => user.id)
#     end
#     hash = {:leads=>leads,:userList=>userList}
#     return hash
# end


def self.fetchLeadList(user)
	leads = []
	userList = []
	case user.user_role.role_type.to_sym  
    when :admin
      leads = UserLeads.includes(:lead).all  
      userList = User.where("id != ?", current_user.id)   
    when :company
      userList = Company.where(:company_admin_id => user.id).pluck(:company_user_id)
      users = userList
      userList << user.id
      leads = UserLeads.select("distinct(lead_id)").where(:user_id => userList)
      users = users.collect{|user| User.find(user)}
    when :employee
      leads = UserLeads.includes(:lead).where(:user_id => user.id)
    end
    hash = {:leads=>leads,:userList=>users}
end

  def self.checkLeadStatus(status)
     status = status ? "Active" : "Inactive"
    
  end

end


