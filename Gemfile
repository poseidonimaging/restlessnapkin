source "https://rubygems.org"
ruby '1.9.3'
gem "sinatra"
gem "activerecord"
gem "sinatra-activerecord"

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
