class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.boolean :active, :default => true
      t.string :name
      t.string :email
      t.string :address
      t.integer :phone, :limit => 8
      t.string :refferred_by
      t.boolean :guest_pass_issued
      t.string :lead_source
      t.string :dues_value
      t.string :enrolment_value
      t.string :notes
      t.integer :company_id

      t.timestamps
    end
  end
end
