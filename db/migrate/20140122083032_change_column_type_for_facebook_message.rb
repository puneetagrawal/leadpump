class ChangeColumnTypeForFacebookMessage < ActiveRecord::Migration
  def up
    change_column :social_messages, :facebookMessage, :text
    change_column :social_messages, :gmailMessage, :text
    change_column :social_messages, :twitterMessage, :text

    change_column :landing_pages, :header_text, :text
    change_column :landing_pages, :intro_text, :text
    change_column :landing_pages, :mission_text, :text

    change_column :previews, :header_text, :text
    change_column :previews, :intro_text, :text
    change_column :previews, :mission_text, :text
	end
	def down
	    # This might cause trouble if you have strings longer
	    # than 255 characters.
	    change_column :social_messages, :facebookMessage, :string
	    change_column :social_messages, :gmailMessage, :string
	    change_column :social_messages, :twitterMessage, :string

	    change_column :landing_pages, :header_text, :string
	    change_column :landing_pages, :intro_text, :string
	    change_column :landing_pages, :mission_text, :string

	    change_column :previews, :header_text, :string
	    change_column :previews, :intro_text, :string
	    change_column :previews, :mission_text, :string
	end
end
