class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer  :company_user_id
      t.integer  :company_admin_id	
      t.timestamps
    end
  end
end
