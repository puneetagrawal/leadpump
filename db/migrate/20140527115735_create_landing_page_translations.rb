class CreateLandingPageTranslations < ActiveRecord::Migration
  def change
    create_table :landing_page_translations do |t|

      t.timestamps
    end
  end
end
