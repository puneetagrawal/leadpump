
require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, GMAIL_SECRET, GMAIL_KEY
  importer :yahoo, YAHOO_SECRET, YAHOO_KEY
  #importer :live, "0000000040112520", "X5fYoftJYclFsID77zl3mt-HGYkEdCvz"
  # importer :facebook, "client_id", "client_secret"
  importer :hotmail, "0000000044119D8D", "guONzW6a0U1QR70sTxv4riJw0zvh4W-s"
end