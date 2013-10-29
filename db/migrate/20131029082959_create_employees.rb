class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
