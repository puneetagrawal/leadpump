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
    resource.trial = true
    @planPerUser = PlanPerUserRange.find(params[:planPerUserId])
    if resource.valid?
      planType = params[:planType] == '2' ? 'yearly' : 'monthly'
      amt = User.signUpAmount(params[:planPerUserId], params[:discountOnUsers], planType)
      total_amount = amt["amount"].to_i * 100
      begin
        email = params["user"]["email"].to_s
        customer = Stripe::Customer.create(
          :email => email,
          :description => "Subscribed for #{@planPerUser.plan.name} plan.",
          :card  => params["user"]["subscription_attributes"]["stripe_card_token"]
          )
        # charge = Stripe::Charge.create(
        #       :amount => total_amount, # in cents
        #       :currency => "usd",
        #       :customer => customer.id
        # )
        if resource.save
         date = planType == "monthly" ? Date.today + 45 : Date.today + 380
         Subscription.saveSubscription(resource, @planPerUser.id, params["user"]["subscription_attributes"]["stripe_card_token"], date, amt["amount"].to_i, params[:discountOnUsers], params[:no_of_locations], planType, customer.id, "")
          #Subscription.saveSubscription(resource, @planPerUser.id, params["user"]["subscription_attributes"]["stripe_card_token"], DateTime.strptime("2013-12-30 11:59 pm", '%Y-%m-%d %I:%M %p'), amt["amount"].to_i, params[:discountOnUsers], params[:no_of_locations], planType)
          sign_in(resource_name, resource)  
          flash[:notice] = "Thankyou for registration."
          redirect_to dashboard_path
        end
        rescue Stripe::CardError => e
        body = e.json_body
        err  = body[:error]
        @cardError = "#{err[:message]}"
        render :action => "new"
      rescue Stripe::InvalidRequestError => e
        @cardError = "Invalid parameters were supplied to Stripe API"
        render :action => "new"
      rescue Stripe::AuthenticationError => e
        @cardError = "Authentication with Stripe's API failed"
        render :action => "new"
      rescue Stripe::APIConnectionError => e
        @cardError = "Network communication with Stripe failed"
        render :action => "new"
      rescue Stripe::StripeError => e
        @cardError = "Display a very generic error to the user, and maybe send yourself an email"
        render :action => "new"
      rescue => e
        @cardError = "Something bad happened, Please try again"
        render :action => "new"
      end
    else    
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