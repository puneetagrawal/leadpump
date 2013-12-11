class CreateSaleReports < ActiveRecord::Migration
  def change
    create_table :sale_reports do |t|
      t.string :s_type
      t.integer :contract
      t.integer :amount
      t.string :name
      t.string :source
      t.string :report
      t.integer :mem_no
      t.integer :commission
      t.integer :sale_prod_id
      t.integer :eft

      t.timestamps
    end
  end
end
