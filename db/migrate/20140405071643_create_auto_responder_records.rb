class CreateAutoResponderRecords < ActiveRecord::Migration
  def change
    create_table :auto_responder_records do |t|
      t.integer :auto_responder_id
      t.integer :user_lead_id
      t.boolean :mail_sent
      t.date :respond_date

      t.timestamps
    end
  end
end
