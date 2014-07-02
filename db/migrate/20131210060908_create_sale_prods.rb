class CreateSaleProds < ActiveRecord::Migration
  def change
    create_table :sale_prods do |t|
      t.integer :call, :limit => 8
      t.integer :appointment, :limit => 8
      t.integer :referral, :limit => 8
      t.integer :mail, :limit => 8
      t.integer :net, :limit => 8
      t.integer :user_id

      t.timestamps
    end
  end
end
