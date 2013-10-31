class CreateLeads < ActiveRecord::Migration
  def change
    create_table :leads do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :address
      t.string :refferred_by
      t.string :lead_source
      t.string :dues_value
      t.string :enrolment_value
      t.string :notes

      t.timestamps
    end
  end
end
