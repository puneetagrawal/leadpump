class AddAbcParamToLead < ActiveRecord::Migration
  def change
    add_column :leads, :barcode, :string
    add_column :leads, :member_id, :string
    add_column :leads, :gender, :string, default: "male"
  end
end
