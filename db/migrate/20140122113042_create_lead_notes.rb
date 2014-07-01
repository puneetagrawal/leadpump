class CreateLeadNotes < ActiveRecord::Migration
  def change
    create_table :lead_notes do |t|
      t.text :notes
      t.datetime :time_stam
      t.integer :lead_id

      t.timestamps
    end
  end
end
