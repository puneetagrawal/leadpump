
require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, GMAIL_SECRET, GMAIL_KEY
  importer :yahoo, YAHOO_SECRET, YAHOO_KEY
  #importer :live, "0000000040112520", "X5fYoftJYclFsID77zl3mt-HGYkEdCvz"
  # importer :facebook, "client_id", "client_secret"
  importer :hotmail, "000000004810E275", "crEyWbhPXnOujsALez0rqU7q7-YHBaU7"
end