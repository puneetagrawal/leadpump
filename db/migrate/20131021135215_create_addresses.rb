class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :city
      t.string :zip             
      t.string :state              
      t.string :phone
      t.string :country
      t.string :user_id
      t.timestamps
    end
  end
end
