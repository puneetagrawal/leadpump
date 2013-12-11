class SaleProdsController < ApplicationController
  def index
    @sale_todate = SaleProd.fetchProdDataUpToDate(current_user, Date.today)
    @sale_tody = SaleProd.fetchProdDataToDay(current_user, Date.today)
    @gross_values = SaleProd.fetchGrossPaper(@sale_todate, @sale_tody)
    @date = Date.today
    logger.debug(@gross_paper)
  end

  def new
  	@saleProd = SaleProd.new
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
    @date = date
    logger.debug(@gross_values)
    respond_to do |format|
      format.js 
    end
  end

end
