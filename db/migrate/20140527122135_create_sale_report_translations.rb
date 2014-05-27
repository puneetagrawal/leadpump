class CreateSaleReportTranslations < ActiveRecord::Migration
  def change
    create_table :sale_report_translations do |t|

      t.timestamps
    end
  end
end
