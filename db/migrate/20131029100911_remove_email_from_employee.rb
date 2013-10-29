class RemoveEmailFromEmployee < ActiveRecord::Migration
  def up
    remove_column :employees, :email
    remove_column :employees, :password
  end

  def down
    add_column :employees, :email, :string
  end
end
