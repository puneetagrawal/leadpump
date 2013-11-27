class CreateOptInLeads < ActiveRecord::Migration
  def change
    create_table :opt_in_leads do |t|
      t.string :name
      t.string :email
      t.integer :phone
      t.string :source
      t.integer :referrer_id

      t.timestamps
    end
  end
end
