class AddUserIdToHtmlCodeImage < ActiveRecord::Migration
  def change
    add_column :html_code_images, :user_id, :integer
  end
end
