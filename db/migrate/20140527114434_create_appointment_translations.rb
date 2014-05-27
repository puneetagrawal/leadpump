class CreateAppointmentTranslations < ActiveRecord::Migration
  def up
    Appointment.create_translation_table!({
      task: :string
    }, {
      migrate_data: true
    })
  end

  def down
    Appointment.drop_translation_table! migrate_data: true
  end
end
