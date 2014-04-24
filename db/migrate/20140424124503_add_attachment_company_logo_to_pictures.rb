class AddAttachmentCompanyLogoToPictures < ActiveRecord::Migration
  def self.up
    change_table :pictures do |t|
      t.attachment :company_logo
    end
  end

  def self.down
    drop_attached_file :pictures, :company_logo
  end
end
