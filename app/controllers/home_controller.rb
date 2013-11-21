class HomeController < ApplicationController
	skip_before_filter :authenticate_user!, :only => [:calculateAmount, :terms, :welcome]

    def index
    	@user = User.new
    end

    def terms
    
    end

    def social_inviter
      # @referrer = User.find(params[:token])
      # logger.debug @referrer
      # logger.debug "+++++++++++++"
    end

    def welcome
    end

    def calculateAmount
        @msg = User.signUpAmount(params[:plan_per_user_range], params[:du], params[:dp])
        respond_to do |format|
          format.json { render json: @msg}
        end
   end  

  def fillpopupcontent
    if(params[:urls].include? 'company')
      @user = User.find(params[:id])
    else
      @lead = Lead.find(params[:id])
    end
  respond_to do |format|
    format.js 
  end
end

def changestatus
  if(params[:urls].include? 'company')
      @object = User.find(params[:leadId])
    else
      @object = Lead.find(params[:leadId])
    end
  respond_to do |format|
    format.js 
  end
end

def saveleadstatus
  if(params[:urls].include?'company')
    object = User.find(params[:leadId])  
    object.active = params[:status] == "false" ? false : true
    status = Lead.checkLeadStatus(object.active)
  else
    object = Lead.find(params[:leadId])  
    object.status = params[:status]
    status = params[:status]
  end
   object.save
  
  msg = {"status"=>status}
  render json:msg
end

def deleteRowByajax
  if params[:uri].include?'company'
     object = User.find(params[:leadId])
     company = Company.where(:company_user_id=>object.id)
     if company.present?
      company.each do|user|
        user.destroy
      end
    end
  else
     object = Lead.find(params[:leadId])
     if object.present?
        userleads = UserLeads.where(:lead_id=>object.id)
        userleads.each do|userlead|
          userlead.destroy
        end
     end
    object.destroy
  end
  
  msg = {"msg"=>"successfull"}
  respond_to do |format|
    format.json { render json: msg}
  end
end

end
