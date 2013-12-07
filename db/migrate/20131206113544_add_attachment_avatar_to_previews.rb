class AddAttachmentAvatarToPreviews < ActiveRecord::Migration
  def self.up
    change_table :previews do |t|
      t.has_attached_file :avatar
    end
  end

  def self.down
    drop_attached_file :previews, :avatar
  end
end
