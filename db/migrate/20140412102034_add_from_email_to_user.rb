class AddFromEmailToUser < ActiveRecord::Migration
  def change
    add_column :users, :from_email, :string
  end
end
