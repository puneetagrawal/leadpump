class AddTitleToFrontDeskDescs < ActiveRecord::Migration
  def change
    add_column :front_desk_descs, :title, :string
  end
end
