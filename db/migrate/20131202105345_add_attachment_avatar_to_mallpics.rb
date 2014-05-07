class AddAttachmentAvatarToMallpics < ActiveRecord::Migration
  def self.up
    change_table :mallpics do |t|
      t.has_attached_file :avatar
    end
  end

  def self.down
    drop_attached_file :mallpics, :avatar
  end
end
