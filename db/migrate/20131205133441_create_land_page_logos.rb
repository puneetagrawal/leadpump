class CreateLandPageLogos < ActiveRecord::Migration
  def change
    create_table :land_page_logos do |t|
      t.integer :landing_page_id

      t.timestamps
    end
  end
end
