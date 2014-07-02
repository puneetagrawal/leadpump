class AddTaskToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :task, :string
    add_column :appointments, :appdateTime, :datetime
    add_column :appointments, :user_id, :integer
  end
end
