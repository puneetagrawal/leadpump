 require 'net/http'
 require 'net/https'
 require 'uri'
 require 'rexml/document'

 class VipleadsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:acceptInvitation, :mallitems,:savereferral,:trackEmail,:viewmallitem,:download]
  layout 'reflanding', only: [:acceptInvitation]
  
  def index
    @leads = UserLeads.includes(:lead).where("leads.lead_source = ? and user_id = ?", "vip", current_user.id).paginate( :page => params[:page], :per_page => 100)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def filter_rec
    @leads = VipLead.fetchList(current_user.id).paginate( :page => params[:page], :per_page => params[:search_val])
    respond_to do |format|
      format.js { render "index" }
    end
  end

  def show
  end

  def edit
  end

  def create
    associate = params["inputs"]["lead"]["associate"]
    error = ''
    (1..5).each do |vip| 
      if !params["inputs"]["vip_#{vip}"].blank?
        viplead = Lead.new(params["inputs"]["vip_#{vip}"])
        if viplead.valid?
          VipLead.saveLead(viplead,current_user,associate)
        else
          error = "Please correct your email or phone"
        end
      end
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
   
   if current_user.isSocialInvitable || current_user.isAdmin
    if params[:code].present?
      email = request.env['omnicontacts.user'][:email]
      session[:email_user] = email
      @token = params[:code]
      @gmail_contacts = request.env['omnicontacts.contacts']
      if @gmail_contacts.present?
        GmailFriend.savegmailContact(@gmail_contacts, current_user, @token)
      end
      @emailAuth = true 
    elsif params[:oauth_token].present?
      unless request.env['omnicontacts.contacts'].blank?
        email = request.env['omnicontacts.user'][:email]
        session[:email_user] = email
        @token = params[:oauth_token]
        @yahoo_contacts = request.env['omnicontacts.contacts']
        GmailFriend.saveyahooContact(@yahoo_contacts, current_user, @token)
      end
      @emailAuth = true 
    end         
  else
    flash[:notice] = "Sorry! you are not autherise user."
    redirect_to home_index_path  
    return false
  end
  @picture_user = Picture.fetchCompanyLogo(current_user.id)
  @lead = Lead.new
end

def delete
end

def update
end

def invites
end

def fetchContacts
  token = params[:token]
  if(params[:uri].include? 'yahoo')
    @contacts = GmailFriend.order("name ASC").where(:user_id=> current_user.id,:source=>"yahoo",:access_token=>token)
  else
    @contacts = GmailFriend.order("name ASC").where(:user_id=> current_user.id, :source=>"gmail",:access_token=>token)
  end
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
      Emailer.gmail_referral_mail(email, token, emailMessage, sec_token, subject, url,session[:email_user]).deliver
      sents_count += 1
      Stats.saveEsents(current_user.id, sents_count, email)
    end
  end
  Emailer.sendrewards(session[:email_user], token).deliver
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
      Emailer.fb_referral_mail(email, token, emailMessage, subject, url,session[:email_user]).deliver
    end
  end
  Emailer.sendrewards(session[:email_user], token).deliver
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
  url = ""
  msg = ""
  if user.checkLeadLimit
    opt_in_lead = OptInLead.where(:email=>params[:email],:referrer_id=>user.id, :source=>params[:source]).last
    msg = "Sorry! your link is invalid or expired."
    if !opt_in_lead.present?
      lead  = Lead.new(:name=>params[:name],:lname=>params[:lname],:email=>params[:email],:lead_source=>params[:source],:phone=>params[:phone])
      if lead.save
        UserLeads.create(:user_id=>user.id, :lead_id=>lead.id)
        user.saveLeadCount
        OptInLead.create(:name=>params[:name],:source=>params[:source], :email=>params[:email],:phone=>params[:phone], :referrer_id=>user.id)
        if params[:source] == "gmail" && !params[:sec].blank?
          msg = Stats.saveEconverted(user.id, params[:sec])
        end
        msg = "thanks"
      else
        error = lead.errors.full_messages.to_sentence
      end
    end
  else
    msg = "Sorry! your referrer limit have been reached."
  end
  if msg == 'thanks'
    url = "http://#{SERVER_URL}/pass?id=#{user.id}"
  end
  message = {"msg" => msg,"error"=>error,"url"=>url}
  respond_to do |format|
    format.json { render json: message}
  end
end

def mallitems
  user = User.where(:token=>params[:id]).last
  logger.debug(user.id)
  @companymallitem = user.fetchcompanymallitem
  logger.debug(@companymallitem)
end

def trackEmail
  ref = User.where(:token=>params[:token]).last
  gmailfriend = ref.present? ? GmailFriend.where(:secret_token=>params[:sec], :user_id=>ref.id).last : nil
  Stats.saveEoppened(gmailfriend)
  send_file Rails.root.join("public", "track.png"), type: "image/png", disposition: "inline"
end

def vipleadsearchfilter
  vl = VipLead.fetchList(current_user.id)
  like  = "%".concat(params[:viplead].concat("%"))
  @leads = UserLeads.includes(:lead).select("leads.name").where("name ilike ? and user_leads.id IN (?)" , like, vl)
  @users = User.where("name ilike ? ", like).where(:id=> vl.map(&:user_id)).pluck(:id)
  if @leads.blank?
    @leads = UserLeads.where(:user_id => @users)
  end
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
 logger.debug(params)
 params.delete :format
 logger.debug(params)
 @mall = Onlinemall.find(params[:mall_id])
 @pf = WickedPdf.new.pdf_from_string(
  render_to_string('vipleads/download.html.erb',:layout=>false)
  )
 respond_to do |format|
  format.pdf do
    send_data @pf, filename: "pass-#{@mall.title}.pdf", type: 'application/pdf', disposition: 'inline'
  end
end
end

def searchvipleads
  leads =VipLead.fetchList(current_user.id)
  if params[:term].blank?
    leads = UserLeads.includes(:lead).select("distinct(leads.name)").where(:id => leads) 
    list = leads.map {|l| Hash[id: l.id, label: l.lead.name, name: l.lead.name]}
  else
   like  = "%".concat(params[:term].concat("%"))
   leads = UserLeads.includes(:lead).select("distinct(leads.name)").where("name ilike ? and user_leads.id IN (?)" , like, leads) 
   list = leads.map {|l| Hash[id: l.id, label: l.lead.name, name: l.lead.name]}
   if !leads.present?
    userleads = VipLead.fetchList(current_user.id)
    associates = User.select("distinct(name)").where("name ilike ? ", like).where(:id=> userleads.map(&:user_id))
    list = associates.map {|a| Hash[id: a.id, label: a.name, name: a.name]}
  end
end
render json: list
end
end

