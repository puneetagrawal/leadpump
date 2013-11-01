class RegistrationsController < Devise::RegistrationsController
  before_filter :getPlan, :only => [:new]
  def new
    if params[:plan_id]
      @plan = Plan.find(params[:plan_id])
      super
    else
      flash[:notice] = 'Please select one of the plan first!'
      redirect_to new_plan_path
    end
  end

  def create
    puts params
    resource = build_resource(params[:user])
    resource.role_id = Role.find_by_role_type("company").id
    if resource.valid?
      @plan = params["user"]["subscriptions_attributes"]["0"]["plan_id"] ? Plan.find(params["user"]["subscriptions_attributes"]["0"]["plan_id"]) : nil
      #@amount = User.calculate_total_amount(params["user"]["subscriptions_attributes"]["0"]["plan_id"], params[:du], params[:dl], params[:dp])
      @amount = params[:tpa] != '' ? params[:tpa].to_i : @plan.price.to_i
      @amount = @amount * 100
      customer = Stripe::Customer.create(
        :email => params[:email],
        :card  => params["user"]["subscriptions_attributes"]["0"]["stripe_card_token"]
        )
      Stripe::Charge.create(
            :amount => @amount, # in cents
            :currency => "usd",
            :customer => customer.id
      )
      resource.save
      sign_in(resource_name, resource)  
      flash[:notice] = "You have paid $#{@amount/100}. Congratulation you signUp successfully"    
      redirect_to home_index_path()
    else     
      @plan = Plan.find(params["user"]["subscriptions_attributes"]["0"]["plan_id"])
      render :action => "new"
    end
  end

  def update
    super
  end

  def success
  end

  private
  def getPlan

  end
end 