class SaleReportTranslations < ActiveRecord::Base
  def up
    SaleReport.create_translation_table!({
      name: :string,
      report: :string,
      s_type: :string,
      source: :string
    }, {
      migrate_data: true
    })
  end

  def down
    SaleReport.drop_translation_table! migrate_data: true
  end
end
