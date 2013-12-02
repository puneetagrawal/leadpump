class CreateMallpics < ActiveRecord::Migration
  def change
    create_table :mallpics do |t|
      t.integer :onlinemall_id

      t.timestamps
    end
  end
end
