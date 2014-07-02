class AddViponToUser < ActiveRecord::Migration
  def change
    add_column :users, :vipon, :boolean
    add_column :users, :vipcount, :integer
  end
end
