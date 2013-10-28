class DiscountsOnUsersController < ApplicationController
  # GET /discounts_on_users
  # GET /discounts_on_users.json
  def index
    @discounts_on_users = DiscountsOnUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @discounts_on_users }
    end
  end

  # GET /discounts_on_users/1
  # GET /discounts_on_users/1.json
  def show
    @discounts_on_user = DiscountsOnUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @discounts_on_user }
    end
  end

  # GET /discounts_on_users/new
  # GET /discounts_on_users/new.json
  def new
    @discounts_on_user = DiscountsOnUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @discounts_on_user }
    end
  end

  # GET /discounts_on_users/1/edit
  def edit
    @discounts_on_user = DiscountsOnUser.find(params[:id])
  end

  # POST /discounts_on_users
  # POST /discounts_on_users.json
  def create
    @discounts_on_user = DiscountsOnUser.new(params[:discounts_on_user])

    respond_to do |format|
      if @discounts_on_user.save
        format.html { redirect_to @discounts_on_user, notice: 'Discounts on user was successfully created.' }
        format.json { render json: @discounts_on_user, status: :created, location: @discounts_on_user }
      else
        format.html { render action: "new" }
        format.json { render json: @discounts_on_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /discounts_on_users/1
  # PUT /discounts_on_users/1.json
  def update
    @discounts_on_user = DiscountsOnUser.find(params[:id])

    respond_to do |format|
      if @discounts_on_user.update_attributes(params[:discounts_on_user])
        format.html { redirect_to @discounts_on_user, notice: 'Discounts on user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @discounts_on_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discounts_on_users/1
  # DELETE /discounts_on_users/1.json
  def destroy
    @discounts_on_user = DiscountsOnUser.find(params[:id])
    @discounts_on_user.destroy

    respond_to do |format|
      format.html { redirect_to discounts_on_users_url }
      format.json { head :no_content }
    end
  end
end
