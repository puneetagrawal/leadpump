class CreateOnlinemalls < ActiveRecord::Migration
  def change
    create_table :onlinemalls do |t|
      t.string :title
      t.string :link
      t.boolean :active
      t.integer :mallpic_id

      t.timestamps
    end
  end
end
