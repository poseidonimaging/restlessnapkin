source "https://rubygems.org"
ruby '1.9.3'
gem "sinatra"
gem "sinatra-contrib"
gem "activerecord"
gem "sinatra-activerecord"
gem "oauth"
gem "oauth2"
gem "omniauth"
gem "omniauth-oauth2"
gem "omniauth-twitter"
gem "rest-client"
gem "stripe"

group :production, :staging do
	gem "mysql2"
	gem "newrelic_rpm"
	gem "unicorn", :platforms => :ruby
end

group :development do
	gem "sqlite3"
	gem "shotgun"
	gem "tux"
end

# The rerun command restarts the app if your files change
gem "rerun"
gem 'rb-fsevent', '~> 0.9.1'
gem "json"