class AddExtLinkToLandingPage < ActiveRecord::Migration
  def change
    add_column :landing_pages, :ext_link, :string
  end
end
