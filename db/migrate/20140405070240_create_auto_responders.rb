class CreateAutoResponders < ActiveRecord::Migration
  def change
    create_table :auto_responders do |t|
      t.date :respond_date
      t.string :subject
      t.string :message
      t.integer :user_id
      t.integer :user_lead

      t.timestamps
    end
  end
end
