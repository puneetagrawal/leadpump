class ChangeDataTypeForPhone < ActiveRecord::Migration
  def up
  	change_column :appointments, :phone, :string
  end

  def down
  	change_column :appointments, :phone, :integer
  end
end
