class AddAttachmentAvatarToHtmlCodeImages < ActiveRecord::Migration
  def self.up
    change_table :html_code_images do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :html_code_images, :avatar
  end
end
