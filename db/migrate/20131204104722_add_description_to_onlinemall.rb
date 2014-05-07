class AddDescriptionToOnlinemall < ActiveRecord::Migration
  def change
    add_column :onlinemalls, :description, :string
  end
end
