 require 'net/http'
 require 'net/https'
 require 'uri'
 require 'rexml/document'

 class VipleadsController < ApplicationController
  
  def index
    @vipleads = VipLead.fetchList(current_user.id).paginate(:page => params[:page], :per_page => 10)
  end

  def filter_rec
    @vipleads = VipLead.fetchList(current_user.id).paginate(:page => params[:page], :per_page => params[:search_val])
  end

  def show
  end

  def edit
  end

  def create
    (1..3).each do |index|
      first_name = params["inputs"]["vip_#{index}"]["first_name"]
      last_name = params["inputs"]["vip_#{index}"]["last_name"]
      phone = params["inputs"]["vip_#{index}"]["phone"]
      if first_name.present? || last_name.present? || phone.present?
        @viplead = VipLead.new(params["inputs"]["vip_#{index}"])
        @viplead.user_id = current_user.id
        @viplead.save
      end  
    end
    respond_to do |format|
      format.js 
    end 
  end

  def new
    if params[:token].present?
      token = params[:token]
      @contacts = GmailContacts::Google.new(token).contacts
      if @contacts.present?
        @contacts.each do |contact|
          email = contact.email != '' ? contact.email : ''
          name = GmailFriend.getName(contact,email)
          if email.present? && name.present?
            gmailcontact = GmailFriend.where(:user_id => current_user.id, :email => email)
            if !gmailcontact.present?
              gmailfreind = GmailFriend.create(:name=>name, :email=>email, :user_id=>current_user.id)
              gmailfreind.save
            end
          end
        end
      end
      @emailAuth = true       
    end
    @vipleads = VipLead.new
  end

  def delete
  end

  def update
  end

  def invites
  end

  def fetchContacts
    @contacts = GmailFriend.where(:user_id=> current_user.id)
    
    respond_to do |format|
      format.js 
    end
  end

  def showvipleads
    @viplead = VipLead.find(params[:id])
    respond_to do |format|
      format.js 
    end
  end

  def sendIvitationToGmailFriend
    emails = params[:emaillist]
    token = current_user.token
    if emails.present?
      emails.each do|email|
        Emailer.gmail_referral_mail(email, token).deliver
      end
    end
    message = {"msg"=> "successfully sent invitations."}
    render json: message
  end

  def sendIvitationToFbFriend
    emails = params[:username]
    token = current_user.token
    if emails.present?
      emails.each do|email|
        Emailer.gmail_referral_mail(email, token).deliver
      end
    end
    message = {"msg"=> "successfully sent invitations."}
    render json: message
  end

  # def acceptInvitation
  #   user = User.find_by_token(params[:token])
  #   msg = ""
  #   token = params[:token]
  #   if !token.blank?
  #     gmailcontact = GmailFriend.find_by_secret_token(token)
  #     if !gmailcontact.present?
  #       msg = "You are unautherise user or your token is invalid"
  #     elsif gmailcontact.active
  #       msg = "You have already used this token"
  #     else
  #       gmailcontact.update_attributes(:active=>true)
  #       gmailReferral.create(:first_name)
  #       #viplead = VipLead.create(:first_name=>gmailcontact.name, :email=>gmailcontact.email, :active=>true, :user_id=>gmailcontact.user_id)
  #       #viplead.save
  #       msg = "You are successfuly created as lead"
  #     end
  #    end
  #    flash[:success] = msg 
  # end

  def acceptInvitation
    @referral  = GmailReferral.new()
    if params[:token].present?
      @ref = User.where(:token=>params[:token]).last
    end
  end

  def savegmailreferral
    user = User.find_by_token(params[:ref_id])
    msg = ""
    if !user.present?
        GmailReferral.create(:name=>params[:name], :email=>params[:email], :user_id=>user.id)
        msg = "You are successfuly created as lead"
    else
      msg = "Sorry! your link is invalid or expired."
    end
    message = {"msg" => msg}
    respond_to do |format|
      format.json { render json: message}
    end
  end

  def vipleadsearchfilter
  vl = VipLead.fetchList(current_user.id)
  vl = vl.present? ? vl.pluck(:id) : []
  @vipleads = VipLead.where("first_name = ? or last_name = ?", params[:viplead],params[:viplead]).where(:id=> vl)
  respond_to do |format|
    format.js 
  end
end

def searchvipleads
  vipleads = VipLead.fetchList(current_user.id)
  vipleads = vipleads.present? ? vipleads.pluck(:id) : []
  if params[:term].blank?
   leads = VipLead.select("distinct(first_name)").where(:id=> vipleads)
   list = leads.map {|l| Hash[id: l.id, label: l.first_name, name: l.first_name]}
  else
   like  = "%".concat(params[:term].concat("%"))
   leads = VipLead.select("distinct(first_name)").where("first_name like ?", like).where(:id=>vipleads)
   list = leads.map {|l| Hash[id: l.id, label: l.first_name, name: l.first_name]}
   if !leads.present?
      leads = VipLead.select("distinct(last_name)").where("last_name like ? ", like).where(:id=>vipleads)
      list = leads.map {|l| Hash[id: l.id, label: l.last_name, name: l.last_name]}
   end
 end
 render json: list
end

end
