class AddCompanyIdToLead < ActiveRecord::Migration
  def change
    add_column :leads, :company_id, :integer
  end
end
