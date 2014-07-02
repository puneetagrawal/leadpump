class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.string :name
      t.integer :phone
      t.string :email
      t.string :notes
      t.string :dues
      t.integer :enrol
      t.string :app_source
      t.string :app_time
      t.date :app_date

      t.timestamps
    end
  end
end
