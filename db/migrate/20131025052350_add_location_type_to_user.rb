class AddLocationTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :locationType, :integer
  end
end
