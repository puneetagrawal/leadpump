class AddLeadIdToAppointment < ActiveRecord::Migration
  def change
    add_column :appointments, :lead_id, :integer
  end
end
