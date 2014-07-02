class DiscountsOnLocationsController < ApplicationController
  # GET /discounts_on_locations
  # GET /discounts_on_locations.json
  def index
    @discounts_on_locations = DiscountsOnLocation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @discounts_on_locations }
    end
  end

  # GET /discounts_on_locations/1
  # GET /discounts_on_locations/1.json
  def show
    @discounts_on_location = DiscountsOnLocation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @discounts_on_location }
    end
  end

  # GET /discounts_on_locations/new
  # GET /discounts_on_locations/new.json
  def new
    @discounts_on_location = DiscountsOnLocation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @discounts_on_location }
    end
  end

  # GET /discounts_on_locations/1/edit
  def edit
    @discounts_on_location = DiscountsOnLocation.find(params[:id])
  end

  # POST /discounts_on_locations
  # POST /discounts_on_locations.json
  def create
    @discounts_on_location = DiscountsOnLocation.new(params[:discounts_on_location])

    respond_to do |format|
      if @discounts_on_location.save
        format.html { redirect_to @discounts_on_location, notice: 'Discounts on location was successfully created.' }
        format.json { render json: @discounts_on_location, status: :created, location: @discounts_on_location }
      else
        format.html { render action: "new" }
        format.json { render json: @discounts_on_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /discounts_on_locations/1
  # PUT /discounts_on_locations/1.json
  def update
    @discounts_on_location = DiscountsOnLocation.find(params[:id])

    respond_to do |format|
      if @discounts_on_location.update_attributes(params[:discounts_on_location])
        format.html { redirect_to @discounts_on_location, notice: 'Discounts on location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @discounts_on_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /discounts_on_locations/1
  # DELETE /discounts_on_locations/1.json
  def destroy
    @discounts_on_location = DiscountsOnLocation.find(params[:id])
    @discounts_on_location.destroy

    respond_to do |format|
      format.html { redirect_to discounts_on_locations_url }
      format.json { head :no_content }
    end
  end
end
