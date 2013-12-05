require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  # importer :gmail, "client_id", "client_secret", {:redirect_path => "/oauth2callback", :ssl_ca_file => "/etc/ssl/certs/curl-ca-bundle.crt"}
  importer :yahoo, "dj0yJmk9Sjg0TTY3SWx4TUpHJmQ9WVdrOWNYSkxjbHB5TjJVbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD0wYw--", "25a75406ff23f30a0e537004bd46cecb31a35277"
  # importer :hotmail, "client_id", "client_secret"
  # importer :facebook, "client_id", "client_secret"
end