class AddResetStatusToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :reset_status, :boolean, :default => false
  end
end
