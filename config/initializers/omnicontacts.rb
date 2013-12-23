require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, GMAIL_SECRET, GMAIL_KEY
  importer :yahoo, YAHOO_SECRET, YAHOO_KEY
  # importer :hotmail, "0000000040110A07", "-1aNOxtIYeSotxXR3BwLwG8e9zjgKF-z", {:redirect_path => "/oauth2callback"}
  # importer :facebook, "client_id", "client_secret"
  importer :hotmail, "000000004810E275", "crEyWbhPXnOujsALez0rqU7q7-YHBaU7"
end