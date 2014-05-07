
require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, GMAIL_SECRET, GMAIL_KEY
  importer :yahoo, YAHOO_SECRET, YAHOO_KEY
  #importer :live, "0000000040112520", "X5fYoftJYclFsID77zl3mt-HGYkEdCvz"
  # importer :facebook, "client_id", "client_secret"
  importer :hotmail, "0000000048110A7E", "cdPc2D3VzL49S2xjIUtmfDR3txQnIawN"
end