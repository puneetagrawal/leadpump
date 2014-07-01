class AddTempNameToPreview < ActiveRecord::Migration
  def change
    add_column :previews, :temp_name, :string
  end
end
