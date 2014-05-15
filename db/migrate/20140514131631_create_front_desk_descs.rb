class CreateFrontDeskDescs < ActiveRecord::Migration
  def change
    create_table :front_desk_descs do |t|
      t.integer :user_id
      t.text :description

      t.timestamps
    end
  end
end
