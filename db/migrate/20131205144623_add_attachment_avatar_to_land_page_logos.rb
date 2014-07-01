class AddAttachmentAvatarToLandPageLogos < ActiveRecord::Migration
  def self.up
    change_table :land_page_logos do |t|
      t.has_attached_file :avatar
    end
  end

  def self.down
    drop_attached_file :land_page_logos, :avatar
  end
end
