class AddHasCancelledToUser < ActiveRecord::Migration
  def change
    add_column :users, :has_cancelled, :boolean
    add_column :users, :original_email, :string
  end
end
