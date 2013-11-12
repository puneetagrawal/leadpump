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
    puts params
    resource = build_resource(params[:user])
    resource.role_id = Role.find_by_role_type("company").id
    if resource.valid?
      @PlanPerUser = params[:planPerUserId] ? PlanPerUserRange.find(params[:planPerUserId]) : nil
      planType = params[:planType] == '2' ? 'yearly' : 'monthly'
      amt = User.signUpAmount(params[:planPerUserId], params[:discountOnUsers], planType)
      total_amount = amt["amount"].to_i * 100
      customer = Stripe::Customer.create(
        :email => params[:email],
        :card  => params["user"]["subscription_attributes"]["stripe_card_token"]
        )
      charge = Stripe::Charge.create(
            :amount => total_amount, # in cents
            :currency => "usd",
            :customer => customer.id
      )
      resource.save
      resource.subscription.plan_per_user_range_id = @planPerUser
      resource.subscription.customer_id = charge.id
      resource.subscription.stripe_card_token = params["user"]["subscription_attributes"]["stripe_card_token"]
      resource.subscription.save
      sign_in(resource_name, resource)  
      flash[:notice] = ""    
      redirect_to success_path()
    else     
      @PlanPerUser = PlanPerUserRange.find(params[:planPerUserId])
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