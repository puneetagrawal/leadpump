class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.string :referrer
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
