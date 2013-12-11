class Lead < ActiveRecord::Base
  attr_accessible :name, :lname, :active, :address, :phone, :email, :address, :refferred_by, :goal, :lead_source, :guest_pass_issued, :dues_value, :enrolment_value, :notes, :user_id, :status, :no_of_days
  belongs_to :user
  after_create :savestatus

  has_many :appointments , :dependent => :destroy
  validates :name, :presence => true
  validates :email, :presence => true, :if => Proc.new { |foo| foo.phone.blank? } 
  #validates :phone, :presence => true, :if => Proc.new { |foo| foo.email.blank? ? true :}
  validates :email, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}, :if => :email?
  validates_numericality_of :phone, :only_integer => true, :allow_nil => true, 
    :message => "can only be number."
  validates :lead_source, :presence => true
  number_regex = /\d[0-9]\)*\z/
  
  #default_scope :order => "created_at DESC"


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


def self.fetchTotalLeads(user)
  totallead = 0
  case user.user_role.role_type.to_sym  
    when :company
      users = User.fetchCompanyUserList(user)
      users << user.id
      leads = UserLeads.where(:user_id=>users)
    when :employee
      leads = UserLeads.includes(:lead).where(:user_id=>user.id)
    end
    totallead = leads.present? && leads.size > 0 ? leads.size : 0
end

def self.fetchLeadList(user)
	leads = []
	userList = []
	case user.user_role.role_type.to_sym  
    when :admin
      leads = UserLeads.includes(:lead).all  
      userList = User.where("id != ?", user.id)   
    when :company
      userList = Company.where(:company_admin_id => user.id).pluck(:company_user_id)
      users = userList
      userList << user.id
      leads = UserLeads.where(:user_id => userList)
      users = users.collect{|user| User.find(user)}
    when :employee
      leads = UserLeads.includes(:lead).where(:user_id => user.id)
    end
    hash = {:leads=>leads,:userList=>users}
end

def self.fetchTodayLeadOfUser(user)
  case user.user_role.role_type.to_sym  
    when :admin
      leads = Lead.where("lead_source not in (?) and created_at >= ?", ["email","fb","twitter"], Date.today)
    when :company
      userList = Company.where(:company_admin_id => user.id).pluck(:company_user_id)
      users = userList
      userList << user.id
      leads = UserLeads.includes(:lead).where("leads.lead_source not in (?) and leads.created_at >= ?", ["email","fb","twitter"], Date.today).where(:user_id => userList)
    when :employee
      leads = UserLeads.includes(:lead).where("leads.lead_source not in (?) and leads.created_at >= ?", ["email","fb","twitter"], Date.today).where(:user_id => user.id)
    end
    leads = leads.present? ? leads.size : 0
end

def self.fetchTodaySocailLeadOfUser(user)
  case user.user_role.role_type.to_sym  
    when :admin
      leads = Lead.where("lead_source in (?) and created_at >= ?", ["email","fb","twitter"], Date.today)
    when :company
      userList = Company.where(:company_admin_id => user.id).pluck(:company_user_id)
      users = userList
      userList << user.id
      leads = UserLeads.includes(:lead).where("leads.lead_source in (?) and leads.created_at >= ?", ["email","fb","twitter"], Date.today).where(:user_id => userList)
    when :employee
      leads = UserLeads.includes(:lead).where("leads.lead_source in (?) and leads.created_at >= ?", ["email","fb","twitter"], Date.today).where(:user_id => user.id)
    end
    leads = leads.present? ? leads.size : 0
end

  def self.checkLeadStatus(status)
     status = status ? "Active" : "Inactive"
  end

  def self.assigndeletedleadtocompany(user)
    company = user.fetchCompany
    userleads = UserLeads.where(:user_id=>user.id)
    if userleads.present?
      logger.debug(userleads)
      userleads.each do |lead|
        lead.user_id = company.id
        lead.save
      end
    end
  end

protected
def savestatus
  self.status = "Active"
  self.save
end

end


