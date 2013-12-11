class SaleReport < ActiveRecord::Base
  attr_accessible :amount, :commission, :contract, :eft, :mem_no, :name, :report, :s_type, :sale_prod_id, :source,:cheque

  belongs_to :sale_prod
end
