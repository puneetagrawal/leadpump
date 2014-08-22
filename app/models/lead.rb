require 'savon'
class Lead < ActiveRecord::Base
  attr_accessible :name, :lname, :active, :address, :phone, :email, :address, :refferred_by,
   :goal, :lead_source, :guest_pass_issued,:notes, :user_id, 
   :status, :no_of_days, :associate, :gender, :member_id, :barcode, :state, :city, :zip, :country,
   :age, :is_member, :currently_exercise, :program_span

  belongs_to :user
  has_many :news_feeds
  after_create :insert_prospect_abc, :savestatus
  #after_save :savestatus if self.token.blank?

  has_many :appointments , :dependent => :destroy
  has_many :lead_notes , :dependent => :destroy, :class_name => "LeadNotes"
  validates :name, :presence => true
  validates :email, :presence => true, :if => Proc.new { |foo| foo.phone.blank? } 
  #validates :phone, :presence => true, :if => Proc.new { |foo| foo.email.blank? ? true :}
  validates :phone, :format => {:with => /^\d+(-\d+)*$/}
  validates :email, :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}, :if => :email?
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

def fullname
  "#{self.name} #{self.lname}"
end

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

def self.fetchAppointmentData(lead_id)
  lead = Lead.find(lead_id)
  appointment = Appointment.find_by_lead_id(lead.id)
  task = ''
  hour = ''
  min = ''
  zone = ''
  if appointment.present?
    date = appointment.app_date_time.strftime("%m/%d/%Y")
    task = appointment.task
    hour = appointment.app_date_time.hour
    min = appointment.app_date_time.min
    if hour >= 12 
      zone = "pm"
      hour = appointment.app_date_time.hour - 12
    else
      zone = "am"
    end
  end
  tasklist = ["Schedule call", "Schedule tour", "Schedule sign up"]
  hash_list = {tasklist: tasklist, lead: lead, date: date, task: task, hour: hour, min: min, zone: zone}
  return hash_list
end




def self.fetchLeadList(user)
	leads = []
	userList = []
	case user.user_role.role_type.to_sym  
    when :admin
      leads = UserLeads.includes(:lead).order('leads.created_at DESC')  
      userList = User.where("id != ?", user.id)   
    when :company
      userList = Company.where(:company_admin_id => user.id).pluck(:company_user_id)
      users = userList
      userList << user.id
      leads = UserLeads.includes(:lead).where(:user_id => userList).order('leads.created_at DESC')
      users = users.collect{|user| User.find(user)}
    when :employee
      leads = UserLeads.includes(:lead).where(:user_id => user.id).order('leads.created_at DESC')
    end
    leads = leads.delete_if{|ld|  Lead.find_by_id(ld.lead_id).nil?}
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
    if user.isEmployee
      company = user.fetchCompany
      userleads = UserLeads.where(:user_id=>user.id)
      if userleads.present?
        userleads.each do |lead|
          lead.user_id = company.id
          lead.save
        end
      end
    end
  end

  def self.get_member_list_from_abc
    leads = Lead.where("status = ? and member_id != ? and barcode != ?", "Active", "", "")
    if leads.size > 0
      leads.each do |lead|
        lead.change_member_status
      end
    end
  end
  
  def change_member_status
    url = "https://webservice.abcfinancial.com/ws/getMemberList/9003?memberId=#{self.member_id}&joinType=Prospect"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.path + "?" + uri.query)
    request.basic_auth 'leadpump.com', 'sh1kq5Da95W4'
    response = http.request(request).body
    xml = Nokogiri::XML(response)
    stts = ""
    xml.xpath("//status").each do |game|
      stts = game.xpath("//joinType").text
    end
    self.status = stts == "Member" ? 'Member' : 'Active'
    self.save
  end

protected
def savestatus
  self.status = "Active"
  token = SecureRandom.urlsafe_base64(self.id, false)
  self.lead_token = token[0, 10]
  self.save
end

def insert_prospect_abc
  @wsdl="https://webservice.abcfinancial.com/wsdl/Prospect.wsdl"
  @basic_auth=["leadpump.com","sh1kq5Da95W4"]
  @message = {:firstName=> self.name, :lastName=> self.lname,:gender=>self.gender}
  @contact = {}
  @dates = {}
  @miscellaneous = {}
  @client = Savon::Client.new do |wsdl|
    wsdl.wsdl "https://webservice.abcfinancial.com/wsdl/Prospect.wsdl"
    wsdl.basic_auth @basic_auth
  end
  begin
   response = @client.call(:insert_prospect, :message=>{:arg0=>{:clubNumber=>9003,
    :personal => @message, :contact=>@contact, :dates=> @dates, :miscellaneous=>@miscellaneous}})
   res = response.body[:insert_prospect_response][:return]
   if res.present? && res[:barcode].present? && res[:member_id].present?
    self.member_id = res[:member_id]
    self.barcode = res[:barcode]
    self.save
   end
 rescue Exception => e
 end
end

end


