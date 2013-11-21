class RegistrationsController < Devise::RegistrationsController
  before_filter :getPlan, :only => [:new]
  def new
    if params[:planPerUser]
      @planPerUser = PlanPerUserRange.find(params[:planPerUser])
      super
    else
      flash[:notice] = 'Please select one of the plan first!'
      redirect_to new_plan_path
    end
  end

  def create
    resource = build_resource(params[:user])
    resource.role_id = Role.find_by_role_type("company").id

    if resource.valid?
      @planPerUser = PlanPerUserRange.find(params[:planPerUserId])
      resource.subscription.plan_per_user_range_id = @planPerUser.id
     
      resource.subscription.stripe_card_token = params["user"]["subscription_attributes"]["stripe_card_token"]
      resource.subscription.expiry_date = DateTime.strptime("2013-12-30 11:59 pm", '%Y-%m-%d %I:%M %p')
      planType = params[:planType] == '2' ? 'yearly' : 'monthly'
      amt = User.signUpAmount(params["user"]["subscription_attributes"]["plan_per_user_range_id"], params[:discountOnUsers], planType)
      total_amount = amt["amount"].to_i * 100
      begin
        email = params["user"]["email"].to_s
        customer = Stripe::Customer.create(
          :email => email,
          :description => "Subscribed for #{@planPerUser.plan.name} plan.",
          :card  => params["user"]["subscription_attributes"]["stripe_card_token"]
          )
        charge = Stripe::Charge.create(
              :amount => total_amount, # in cents
              :currency => "usd",
              :customer => customer.id
        )
        if resource.save
          resource.subscription.customer_id = charge.id
          resource.subscription.save
          sign_in(resource_name, resource)  
          redirect_to success_path()
        end
      rescue Stripe::CardError => e
        body = e.json_body
        err  = body[:error]
        @cardError = "#{err[:message]}"
        @planPerUser = PlanPerUserRange.find(params[:planPerUserId])
        render :action => "new"
      rescue Stripe::InvalidRequestError => e
        @cardError = "Invalid parameters were supplied to Stripe API"
        @planPerUser = PlanPerUserRange.find(params[:planPerUserId])
        render :action => "new"
      rescue Stripe::AuthenticationError => e
        @cardError = "Authentication with Stripe's API failed"
        @planPerUser = PlanPerUserRange.find(params[:planPerUserId])
        render :action => "new"
      rescue Stripe::APIConnectionError => e
        @cardError = "Network communication with Stripe failed"
        @planPerUser = PlanPerUserRange.find(params[:planPerUserId])
        render :action => "new"
      rescue Stripe::StripeError => e
        @cardError = "Display a very generic error to the user, and maybe send yourself an email"
        @planPerUser = PlanPerUserRange.find(params[:planPerUserId])
        render :action => "new"
      rescue => e
        @cardError = "Something else happened, Please try again"
        @planPerUser = PlanPerUserRange.find(params[:planPerUserId])
        render :action => "new"
      end
    else     
      @planPerUser = PlanPerUserRange.find(params[:planPerUserId])
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