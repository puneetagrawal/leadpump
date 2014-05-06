class AddUsersCreatedToUser < ActiveRecord::Migration
  def change
    add_column :users, :users_created, :integer, :default=>0
    add_column :users, :leads_created, :integer, :default=>0
  end
end
