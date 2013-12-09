 require 'net/http'
 require 'net/https'
 require 'uri'
 require 'rexml/document'

 class VipleadsController < ApplicationController
  layout 'reflanding', only: [:acceptInvitation]
  
  def index
    @vipleads = VipLead.fetchList(current_user.id).paginate(:page => params[:page], :per_page => params[:search_val])
    @vipleads = @vipleads.collect{|u| u if u.lead.lead_source=="vip"}
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
    viplead1 = Lead.new(params["inputs"]["vip_1"])
    viplead2 = Lead.new(params["inputs"]["vip_2"])
    viplead3 = Lead.new(params["inputs"]["vip_3"])
    error = ''
    if viplead1.valid? && viplead2.valid? && viplead3.valid?
      VipLead.saveLead(viplead1,current_user)
      VipLead.saveLead(viplead2,current_user)
      VipLead.saveLead(viplead3,current_user)
    else
      error = "Please correct your email or phone"
    end
    if error != '' && params[:skip] != 'skip'
      message = {"error"=> error}
      render json: message
    else
      respond_to do |format|
        format.js 
      end
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
    @lead = Lead.new
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
        url = VipLead.fetchgmaillink(token,sec_token, current_user)
        Emailer.gmail_referral_mail(email, token, emailMessage, sec_token, subject, url).deliver
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
        url = VipLead.fetchfblink(token, current_user)
        Emailer.fb_referral_mail(email, token, emailMessage, subject, url).deliver
      end
    end
    message = {"msg"=> "successfully sent invitations."}
    render json: message
  end
  
  def acceptInvitation
    if params[:token].present?
      @ref = User.where(:token=>params[:token]).last
      if @ref.checkLeadLimit
        @landpage = VipLead.fetchTemp(@ref)
        @token = params[:token]
        @source = params[:source]
        @sec = params[:sec]
        @gmailcontact = GmailFriend.where(:secret_token=>params[:sec], :user_id=>@ref.id).last
        if @gmailcontact.present? && !@gmailcontact.visited
          Stats.saveEvisited(@ref.id, @gmailcontact)
        end
      else
        flash[:notice] = "You are requesting wrong link."
        redirect_to home_index_path
      end
    end
  end

  def savereferral
    user = User.find_by_token(params[:ref_id])
    error = ""
    if @ref.checkLeadLimit
      opt_in_lead = OptInLead.where(:email=>params[:email],:referrer_id=>user.id, :source=>params[:source]).last
      msg = "Sorry! your link is invalid or expired."
      if !opt_in_lead.present?
          if !params[:sec].blank?
            lead  = Lead.new(:name=>params[:name],:email=>params[:email],:lead_source=>params[:source],:phone=>params[:phone])
            if lead.save
              UserLeads.create(:user_id=>user.id, :lead_id=>lead.id)
              @ref.saveLeadCount
              OptInLead.create(:name=>params[:name],:source=>params[:source], :email=>params[:email],:phone=>params[:phone], :referrer_id=>user.id)
              msg == "Thanks.You are successfuly Opt in."
              if params[:source] == "gmail"
                msg = Stats.saveEconverted(user.id, params[:sec])
              end
            else
              error = lead.errors.full_messages.to_sentence
            end
          end
      end
    else
      msg = "Sorry! your referrer limit have been reached."
    end
    if msg == 'Thanks.You are successfuly Opt in.'
      @companymallitem = user.fetchcompanymallitem
      respond_to do |format|
        format.js 
      end
    else
      message = {"msg" => msg,"error"=>error}
      respond_to do |format|
        format.json { render json: message}
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
    vl = vl.present? ? vl.pluck(:lead_id) : []
    @vipleads = Lead.where("name = ? ", params[:viplead]).where(:id=> vl,:lead_source=>"vip").pluck(:id)
    @vipleads = UserLeads.where(:lead_id=>@vipleads)
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
  vipleads = vipleads.present? ? vipleads.pluck(:lead_id) : []
  if params[:term].blank?
   leads = Lead.select("distinct(name)").where(:id=> vipleads,:lead_source=>"vip")
   list = leads.map {|l| Hash[id: l.id, label: l.name, name: l.name]}
  else
   like  = "%".concat(params[:term].concat("%"))
   leads = Lead.select("distinct(name)").where("name ilike ?", like).where(:id=>vipleads,:lead_source=>"vip")
   list = leads.map {|l| Hash[id: l.id, label: l.name, name: l.name]}
 end
 render json: list
end


end
