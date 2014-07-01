class AddFileToOnlinemall < ActiveRecord::Migration
  def self.up
    change_table :onlinemalls do |t|
      t.has_attached_file :file
    end
  end

  def self.down
    drop_attached_file :onlinemalls, :file
  end
end
