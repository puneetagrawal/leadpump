class AddUserIdToOnlinemall < ActiveRecord::Migration
  def change
    add_column :onlinemalls, :user_id, :integer
  end
end
