 require 'net/http'
 require 'net/https'
 require 'uri'
 require 'rexml/document'

 class VipleadsController < ApplicationController
  
  def index
    @vipleads = VipLead.fetchList(current_user.id).paginate(:page => params[:page], :per_page => params[:search_val])
  end

  def filter_rec
    @vipleads = VipLead.fetchList(current_user.id).paginate(:page => params[:page], :per_page => params[:search_val])
  end

  def show
  end

  def edit
  end

  def mallitems
    @companymallitem = user.fetchcompanymallitem
  end

  def create
    (1..3).each do |index|
      first_name = params["inputs"]["vip_#{index}"]["first_name"]
      email = params["inputs"]["vip_#{index}"]["email"]
      phone = params["inputs"]["vip_#{index}"]["phone"]
      if first_name.present? || email.present? || phone.present?
        @viplead = VipLead.new(params["inputs"]["vip_#{index}"])
        @viplead.user_id = current_user.id
        if @viplead.save
          lead = Lead.new(:name=>@viplead.first_name,:email=>@viplead.email,:phone=>@viplead.phone,:lead_source=>"vip")
          if lead.save
            UserLeads.create(:user_id=>@viplead.user_id, :lead_id=>lead.id)
          end
        end
      end  
    end
    respond_to do |format|
      format.js 
    end 
  end

  def new
    if current_user.isSocialInvitable
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
    else
      flash[:notice] = "Sorry! you are not autherise user."
      redirect_to home_index_path  
      return false
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
    sents_count = 0
    if emails.present?
      emailMessage = current_user.fetchEmailMessage
      subject = current_user.fetchgmailsubject
      emails.each do|email|
        sec_token = GmailFriend.where(:email=>email,:user_id=>current_user.id).last
        sec_token = sec_token.present? ? sec_token.secret_token : ''
        Emailer.gmail_referral_mail(email, token, emailMessage, sec_token, subject).deliver
        sents_count += 1
        Stats.saveEsents(current_user.id, sents_count, email)
      end
    end
    message = {"msg"=> "successfully sent invitations."}
    render json: message
  end

  def sendIvitationToFbFriend
    emails = params[:username]
    token = current_user.token
    if emails.present?
      emailMessage = current_user.fetchFacebookMessage
      subject = current_user.fetchfbsubject
      emails.each do|email|
        Emailer.fb_referral_mail(email, token, emailMessage, subject).deliver
      end
    end
    message = {"msg"=> "successfully sent invitations."}
    render json: message
  end
  
  def acceptInvitation
    if params[:token].present?
      @ref = User.where(:token=>params[:token]).last
      @token = params[:token]
      @sec = params[:sec]
      @source = params[:source]
      @gmailcontact = GmailFriend.where(:secret_token=>params[:sec], :user_id=>@ref.id).last
      if @gmailcontact.present? && !@gmailcontact.visited
        Stats.saveEvisited(@ref.id, @gmailcontact)
      end
    end
  end

  def savereferral
    user = User.find_by_token(params[:ref_id])
    opt_in_lead = OptInLead.where(:email=>params[:email],:referrer_id=>user.id, :source=>params[:source]).last
    msg = "Sorry! your are requesting expired link."
    error = ""
    # if !opt_in_lead.present?
    #     if(!params[:sec].blank? || params[:source] == "fb" || params[:source] == "twitter") 
    #       lead  = Lead.new(:name=>params[:name],:email=>params[:email],:lead_source=>params[:source],:phone=>params[:phone])
    #       if lead.save
    #         UserLeads.create(:user_id=>user.id, :lead_id=>lead.id)
    #         OptInLead.create(:name=>params[:name],:source=>params[:source], :email=>params[:email],:phone=>params[:phone], :referrer_id=>user.id)
    #         if params[:source] == "gmail"
    #           msg = Stats.saveEconverted(user.id, params[:sec])
    #         end
    #       else
    #         error = lead.errors.full_messages.to_sentence
    #       end
    #     end
    # end
    if error != ''
      message = {"msg" => msg,"error"=>error}
      respond_to do |format|
        format.json { render json: message}
      end
    else
      @companymallitem = user.fetchcompanymallitem
      respond_to do |format|
        format.js 
      end
    end
  end

  def trackEmail
      ref = User.where(:token=>params[:token]).last
      gmailfriend = ref.present? ? GmailFriend.where(:secret_token=>params[:sec], :user_id=>ref.id).last : nil
      Stats.saveEoppened(gmailfriend)
      send_file Rails.root.join("public", "track.png"), type: "image/png", disposition: "inline"
   end

  def vipleadsearchfilter
    vl = VipLead.fetchList(current_user.id)
    vl = vl.present? ? vl.pluck(:id) : []
    @vipleads = VipLead.where("first_name = ? or last_name = ?", params[:viplead],params[:viplead]).where(:id=> vl)
    respond_to do |format|
      format.js 
    end
end

def viewmallitem
  @mall = Onlinemall.find(params[:id])
  respond_to do |format|
    format.js 
  end
end

def download
  @mall = Onlinemall.find_by_user_id(2)
  @pf = WickedPdf.new.pdf_from_string(
          render_to_string('vipleads/download.html.erb',:layout=>false)
        )
   respond_to do |format|
      format.pdf do
        send_data @pf, filename: "Invoice-#{@mall.title}.pdf", type: 'application/pdf', disposition: 'inline'
      end
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
