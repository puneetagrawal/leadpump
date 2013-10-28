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
    resource = build_resource(params[:user])
    if resource.valid?
      @amount = User.calculate_total_amount(params["user"]["subscriptions_attributes"]["0"]["plan_id"], params[:du], params[:dl], params[:dp])
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
      respond_with resource, :location => after_sign_up_path_for(resource)
    else     
      @plan = Plan.find(params["user"]["subscriptions_attributes"]["0"]["plan_id"])
      render :action => "new"
    end
  end

  def update
    super
  end

  

  private
  def getPlan

  end
end 