class AddAttachmentFbLogoToPictures < ActiveRecord::Migration
  def self.up
    change_table :pictures do |t|
      t.attachment :fb_logo
    end
  end

  def self.down
    drop_attached_file :pictures, :fb_logo
  end
end
