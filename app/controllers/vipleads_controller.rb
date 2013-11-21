 require 'net/http'
 require 'net/https'
 require 'uri'
 require 'rexml/document'

 class VipleadsController < ApplicationController
  def show
  end

  def edit
  end

  def create
    (1..3).each do |index|
      if params["inputs"]["vip_#{index}"].present?
        @viplead = VipLead.new(params["inputs"]["vip_#{index}"])
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

  def sendIvitationToGmailFriend
    Emailer.gmail_referral_mail().deliver
  end

  def acceptInvitation
    #Emailer.gmail_referral_mail().deliver
    logger.debug(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    user = User.find(1)
    logger.debug(user.reset_password_token)
    msg = ""
    token = params[:token]
    if !token.blank?
      gmailcontact = GmailFriend.find_by_secret_token(token)
      if !gmailcontact.present?
        msg = "You are unautherise user or your token is invalid"
      elsif gmailcontact.active
        msg = "You have already used this token"
      else
        gmailcontact.update_attributes(:active=>true)
        viplead = VipLead.create(:first_name=>gmailcontact.name, :email=>gmailcontact.email, :active=>true, :user_id=>gmailcontact.user_id)
        viplead.save
        msg = "You are successfuly created as lead"
      end
     end
     flash[:success] = msg 
  end

end
