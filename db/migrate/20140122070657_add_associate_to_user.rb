class AddAssociateToUser < ActiveRecord::Migration
  def change
    add_column :users, :associate, :string
  end
end
