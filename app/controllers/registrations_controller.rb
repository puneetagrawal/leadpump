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
        resource.save
        resource.subscription.plan_per_user_range_id = @planPerUser.id
        resource.subscription.customer_id = charge.id
        resource.subscription.stripe_card_token = params["user"]["subscription_attributes"]["stripe_card_token"]
        #@todaydate = "2013-12-30 11:59:59"
        #@todaytime.to_time.strftime('%a %b %d %H:%M:%S %Z %Y')
        #resource.expiry_date = 
        resource.subscription.save
        sign_in(resource_name, resource)  
        redirect_to success_path()
      rescue Exception => e
        @cardError = "Your have problem in your card"
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