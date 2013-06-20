source "https://rubygems.org"
gem "sinatra"
gem "activerecord"
gem "sinatra-activerecord"
#gem "json"

group :production, :staging do
	gem "pg"
	#gem "newrelic_rpm"
end

group :development do
	gem "sqlite3"
	gem "shotgun"
	gem "tux"
end

# The rerun command restarts the app if your files change
gem "rerun"
gem 'rb-fsevent', '~> 0.9.1'
