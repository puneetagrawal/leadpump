class AddVerificationTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :verification_token, :string
    add_column :users, :verified, :boolean, defaut: false
  end
end
