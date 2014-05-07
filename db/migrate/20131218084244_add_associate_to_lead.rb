class AddAssociateToLead < ActiveRecord::Migration
  def change
    add_column :leads, :associate, :string
  end
end
