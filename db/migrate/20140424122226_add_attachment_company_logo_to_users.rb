class AddAttachmentCompanyLogoToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :company_logo
    end
  end

  def self.down
    drop_attached_file :users, :company_logo
  end
end
