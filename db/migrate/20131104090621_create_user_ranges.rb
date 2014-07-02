class CreateUserRanges < ActiveRecord::Migration
  def change
    create_table :user_ranges do |t|
      t.integer :start_range
      t.integer :end_range

      t.timestamps
    end
  end
end
