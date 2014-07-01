class DiscountsOnPeriodsController < ApplicationController
  # GET /discounts_on_periods
  # GET /discounts_on_periods.json
  def index
    @discounts_on_periods = DiscountsOnPeriod.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @discounts_on_periods }
    end
  end

  # GET /discounts_on_periods/1
  # GET /discounts_on_periods/1.json
  def show
    @discounts_on_period = DiscountsOnPeriod.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @discounts_on_period }
    end
  end

  # GET /discounts_on_periods/new
  # GET /discounts_on_periods/new.json
  def new
    @discounts_on_period = DiscountsOnPeriod.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @discounts_on_period }
    end
  end

  # GET /discounts_on_periods/1/edit
  def edit
    @discounts_on_period = DiscountsOnPeriod.find(params[:id])
  end

  # POST /discounts_on_periods
  # POST /discounts_on_periods.json
  def create
    @discounts_on_period = DiscountsOnPeriod.new(params[:discounts_on_period])

    respond_to do |format|
      if @discounts_on_period.save
        format.html { redirect_to @discounts_on_period, notice: 'Discounts on period was successfully created.' }
        format.json { render json: @discounts_on_period, status: :created, location: @discounts_on_period }
      else
        format.html { render action: "new" }
        format.json { render json: @discounts_on_period.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /discounts_on_periods/1
  # PUT /discounts_on_periods/1.json
  def update
    @discounts_on_period = DiscountsOnPeriod.find(params[:id])

    respond_to do |format|
      if @discounts_on_period.update_attributes(params[:discounts_on_period])
        format.html { redirect_to @discounts_on_period, notice: 'Discounts on period was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @discounts_on_period.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discounts_on_periods/1
  # DELETE /discounts_on_periods/1.json
  def destroy
    @discounts_on_period = DiscountsOnPeriod.find(params[:id])
    @discounts_on_period.destroy

    respond_to do |format|
      format.html { redirect_to discounts_on_periods_url }
      format.json { head :no_content }
    end
  end
end
