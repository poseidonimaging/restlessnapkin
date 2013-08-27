
require "rubygems"
require "sinatra"
require "sinatra/activerecord"
require "newrelic_rpm"
require "open-uri"
require "uri"
require "json"
require "oauth"
require "oauth2"
require "omniauth"
require "omniauth-twitter"
require "omniauth-oauth2"
require "rest-client"
require "./models"
load "./order_process.rb"
load "./order_views.rb"
load "./barkeeper.rb"
load "./venue.rb"
load "./liquor.rb"
load "./admin.rb"

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  set :method_override, true
end

configure :development do
  set :database, "sqlite3:///orders.db"
end

configure :production do

  db_yml = YAML::load(File.read(File.join(File.dirname(__FILE__), "config", "database.yml")))
  settings = {
    :adapter    => db_yml["production"]["adapter"],
    :host       => db_yml["production"]["host"],
    :username   => db_yml["production"]["username"],
    :password   => db_yml["production"]["password"],
    :database   => db_yml["production"]["database"],
    :encoding   => db_yml["production"]["encoding"]
  }

  ActiveRecord::Base.establish_connection(settings)
end

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :expire_after => 14400, # In seconds
                           :secret => 'nPiOpaoyqcyeaABv2huEqlvZw6CxkC0Qo71hMlbwMbhmzWAjcndLD5piz9PqXt8'



helpers do
  def phone
    session[:phone] ? session[:phone] : 'No Phone'
  end

  def firstname
    session[:firstname] ? session[:firstname] : 'No Firstname'
  end

  def lastname
    session[:lastname] ? session[:lastname] : 'Hello Stranger'
  end
  
  def venue
    session[:venue] ? session[:venue] : 'No Venue'
  end

  def location
    session[:location] ? session[:location] : 'No Location'
  end

  # define a current_user method, so we can be sure if an user is authenticated
  def current_user
    !session[:uid].nil?
  end

 def pretty_date(stamp)
   now = Time.new
   diff = now - stamp
   day_diff = ((now - stamp) / 86400).floor
 
   day_diff == 0 && (
     diff < 60 && "just now" ||
     diff < 120 && "1 minute ago" ||
     diff < 3600 && (diff / 60).floor.to_s + " minutes ago" ||
     diff < 7200 && "1 hour ago" ||
     diff < 86400 && (diff/3600).floor.to_s + " hours ago") ||
   day_diff == 1 && "Yesterday" ||
   day_diff < 7 && day_diff.to_s + " days ago" ||
   day_diff < 31 && (day_diff.to_s / 7).ceil + " weeks ago";
  end
end

# Starting routes

get '/mprinter' do
  erb :mprinter
end

get '/mprinter/authorize' do
  RestClient.log = logger

  MPRINTER_OAUTH_CLIENT = 'Ehfv3Qk44jJiB8bifM3A'
  MPRINTER_OAUTH_SECRET = 'g91EciYab2LdB83eKaRm'
  MPRINTER_OAUTH_URL    = 'http://manage.themprinter.com/api/v1'

  client = OAuth2::Client.new(MPRINTER_OAUTH_CLIENT, MPRINTER_OAUTH_SECRET, :site => MPRINTER_OAUTH_URL, :token_url => MPRINTER_OAUTH_URL + '/token')
  token = client.client_credentials.get_token({ :client_id => MPRINTER_OAUTH_CLIENT, :client_secret => MPRINTER_OAUTH_SECRET })
  response = token.get('/api/v1/account')
  session[:mprinter_access_token] = token.token.to_s

  redirect '/mprinter'
end

get '/mprinter/add_device' do
  RestClient.log = logger

  MPRINTER_OAUTH_CLIENT = 'Ehfv3Qk44jJiB8bifM3A'
  MPRINTER_OAUTH_SECRET = 'g91EciYab2LdB83eKaRm'
  MPRINTER_OAUTH_URL    = 'http://manage.themprinter.com/api/v1'
  
  client = OAuth2::Client.new(MPRINTER_OAUTH_CLIENT, MPRINTER_OAUTH_SECRET, :site => MPRINTER_OAUTH_URL, :token_url => MPRINTER_OAUTH_URL + '/token')
  client.connection.response :logger
  token = client.client_credentials.get_token({ :client_id => MPRINTER_OAUTH_CLIENT, :client_secret => MPRINTER_OAUTH_SECRET })
  token.post(MPRINTER_OAUTH_URL + '/devices', :serial => 'KMHELM')
  #puts token.get(MPRINTER_OAUTH_URL + "/devices").response.body.to_s
  #RestClient.post MPRINTER_OAUTH_URL + '/devices', :serial => 'KMHELM', token.headers
end

# Support for OAuth failure
get '/auth/failure' do
  flash[:notice] = params[:message] # if using sinatra-flash or rack-flash
  redirect '/'
end

get '/example.json' do
  content_type :json
  {:key1 => 'value1', :key2 => 'value2'}.to_json
end

get '/hello/:name.json' do
  content_type :json
  {"message" => "Hello #{params[:name]}!"}.to_json
end