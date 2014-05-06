class CreateLandingPages < ActiveRecord::Migration
  def change
    create_table :landing_pages do |t|
      t.string :land_type
      t.string :temp_name
      t.string :header_text
      t.string :intro_text
	  t.string :mission_text     
	  t.string :header_color
	  t.string :bg_color
	  t.string :no_of_days
	  t.integer :land_page_logo_id
	  t.integer :user_id
      t.timestamps
    end
  end
end
