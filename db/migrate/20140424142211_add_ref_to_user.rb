class AddRefToUser < ActiveRecord::Migration
  def change
    add_column :users, :ref, :integer
  end
end
