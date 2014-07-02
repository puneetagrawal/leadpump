class AddEmployeeToAppointments < ActiveRecord::Migration
  def change
  	 add_column :appointments, :employee_id, :integer
  end
end
