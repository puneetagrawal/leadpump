class SaleProdsController < ApplicationController
  def index
    @sale_todate = SaleProd.fetchProdDataUpToDate(current_user, Date.today)
    @sale_tody = SaleProd.fetchProdDataToDay(current_user, Date.today)
    @gross_values = SaleProd.fetchGrossPaper(@sale_todate, @sale_tody)
    @appointment = SaleProd.fetchAppointment(Date.today, current_user)
    @date = Date.today
  end

  def new
  	@saleProd = SaleProd.new
    @sale_tody = SaleProd.fetchProdDataToDay(current_user, Date.today)
    @gross_values = SaleProd.fetchGrossPaper([], @sale_tody)
    @appointment = SaleProd.fetchAppointment(Date.today, current_user)
  end

  def create
  	@saleprod = SaleProd.new(params[:sale_prod])
  	@saleprod.user_id = current_user.id
  	params[:rep].each_with_index do |re,i|
		i = i+1
		@saleprod.sale_reports << SaleReport.new(params[:rep]["#{i}"])	  		
	end
	@saleprod.save
	redirect_to sale_prods_path
  end

  def addnewprodrow
  	@old = params[:id].to_i
   	@id = @old + 1
  	respond_to do |format|
      format.js 
    end
  end

  def showproduction
    date = Date.strptime(params[:date], "%d/%m/%Y")
    @sale_todate = SaleProd.fetchProdDataUpToDate(current_user, date)
    @sale_tody = SaleProd.fetchProdDataToDay(current_user, date)
    @gross_values = SaleProd.fetchGrossPaper(@sale_todate, @sale_tody)
    @appointment = SaleProd.fetchAppointment(Date.today, current_user)
    @date = date
    respond_to do |format|
      format.js 
    end
  end

  def showreport
    logger.debug(params)
    @user = User.find(params[:id])
    date = Date.today
    @sale_todate = SaleProd.fetchProdDataUpToDate(@user, date)
    @sale_tody = SaleProd.fetchProdDataToDay(@user, date)
    if params[:name] == "daily_rep"
      @gross_values = SaleProd.fetchGrossMap(@sale_tody)
    elsif params[:name] == "monthly_rep"
      @gross_values = SaleProd.fetchGrossMap(@sale_todate)
    elsif params[:name] == "project_rep"
      @project = "test"
      @gross_values = SaleProd.fetchGrossMap(@sale_todate)
    end
    respond_to do |format|
      format.js 
    end
  end

end
