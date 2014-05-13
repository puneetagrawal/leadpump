class AddDusrToUser < ActiveRecord::Migration
  def change
    add_column :users, :dusr, :boolean, default: :false
  end
end
