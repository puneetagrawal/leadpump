class CreateHtmlCodeImages < ActiveRecord::Migration
  def change
    create_table :html_code_images do |t|

      t.timestamps
    end
  end
end
