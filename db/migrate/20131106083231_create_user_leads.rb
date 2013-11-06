class CreateUserLeads < ActiveRecord::Migration
  def change
    create_table :user_leads do |t|
      t.integer :user_id
      t.integer :lead_id
      t.timestamps
    end
  end
end
