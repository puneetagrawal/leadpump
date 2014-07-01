class AddChequeToSaleReport < ActiveRecord::Migration
  def change
    add_column :sale_reports, :cheque, :integer
  end
end
