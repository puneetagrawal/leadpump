class ChangeTimeInAppointments < ActiveRecord::Migration
  def up
  	change_column :appointments, :app_time, :string
  end

  def down
  	change_column :appointments, :app_time, :string
  end
end
