class AddAttachmentViplogoToPictures < ActiveRecord::Migration
  def self.up
    change_table :pictures do |t|
      t.has_attached_file :viplogo
    end
  end

  def self.down
    drop_attached_file :pictures, :viplogo
  end
end
