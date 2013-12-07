class CreatePreviews < ActiveRecord::Migration
  def change
    create_table :previews do |t|
      t.string :header_text
      t.string :intro_text
	  t.string :mission_text     
	  t.string :header_color
	  t.string :bg_color
	  t.string :no_of_days
      t.timestamps
    end
  end
end
