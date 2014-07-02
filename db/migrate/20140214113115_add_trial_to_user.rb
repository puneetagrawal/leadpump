class AddTrialToUser < ActiveRecord::Migration
  def change
    add_column :users, :trial, :boolean
  end
end
