class OptInLeadsController < ApplicationController
  
  def index
  	if current_user.isCompany || current_user.isEmployee
  		#users = User.fetchCompanyUserList(current_user)
  		#users = users.present? ? users.collect{|user| user.id} : []
  		#users << current_user.id
		  @opts = OptInLead.where(:referrer_id=>current_user.id).paginate( :page => params[:page], :per_page => 10)
      respond_to do |format|
        format.js
        format.html
      end
	 else
		flash[:notice] = "Sorry you are not authorize user for this action"
		redirect_to home_index_path
		return false
	 end
  end

  def filter_opt
    @opts = OptInLead.where(:referrer_id=>current_user.id).paginate( :page => params[:page], :per_page => params[:search_val])
    respond_to do |format|
      format.js {render "index" }
    end
  end

  def viewContact
  	@opt_in_lead = OptInLead.find(params[:leadId])
  	respond_to do |format|
        format.js 
    end 
  end

  def optlist
    @oplts = OptInLead.where(:referrer_id=>current_user.id)
    if @oplts.present?
      like  = "%".concat(params[:term].concat("%"))
      @opts = OptInLead.where("source ilike ? and id IN (?)", like, @oplts)
      list = @opts.map {|o| Hash[id: o.id, label: o.source, name: o.source]}
      if @opts.blank?
        @associate = User.select("distinct(name)").where("name ilike ? and id IN (?)", like, @oplts.map(&:referrer_id))
        list = @associate.map {|a| Hash[id: a.id, label: a.name, name: a.name]}
      end
    end
    render json: list
  end

  def optsearchfilter
    @oplts = OptInLead.where(:referrer_id=>current_user.id)
    like  = "%".concat(params[:optId].concat("%"))
    @opts = OptInLead.where("source ilike ? and id IN (?)", like, @oplts).paginate( :page => params[:page], :per_page => 10)
    if @opts.blank?
      @users = User.where("name ilike ?", like).pluck(:id)
      @opts = OptInLead.where("referrer_id = ? and id IN (?)", @users, @oplts).paginate( :page => params[:page], :per_page => 10)
    end
    respond_to do |format|
      format.js { render "index" }
    end
  end
end