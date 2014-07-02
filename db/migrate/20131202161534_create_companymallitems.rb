class CreateCompanymallitems < ActiveRecord::Migration
  def change
    create_table :companymallitems do |t|
      t.integer :onlinemall_id
      t.integer :user_id

      t.timestamps
    end
  end
end
