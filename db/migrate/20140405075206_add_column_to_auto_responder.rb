class AddColumnToAutoResponder < ActiveRecord::Migration
  def change
    add_column :auto_responders, :day, :Integer
  end
end
