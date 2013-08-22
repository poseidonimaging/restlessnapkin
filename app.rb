
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
load "./venues.rb"

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  enable :sessions
  set :session_secret, "nPiOpaoyqcyeaABv2huEqlvZw6CxkC0Qo71hMlbwMbhmzWAjcndLD5piz9PqXt8"
  set :method_override, true
end

configure :development do
  set :database, "sqlite3:///orders.db"
  set :session_secret, "nPiOpaoyqcyeaABv2huEqlvZw6CxkC0Qo71hMlbwMbhmzWAjcndLD5piz9PqXt8"
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

# OAuth2 configuration
use Rack::Session::Cookie
use OmniAuth::Builder do
  provider :twitter, 'HnLokC5vWkVC0r1HK4ojOQ', 'WmGe0dWFNvLrtl06Gon4Y6LuVv6UBm57kjyVWXtNjNY'
  #provider :att, 'client_id', 'client_secret', :callback_url => (ENV['BASE_DOMAIN']
end

# Starting routes

get '/twitter' do
  erb "<a href='/auth/twitter'>Sign in with Twitter</a>"
end

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

get '/auth/twitter/callback' do
  # probably you will need to create a user in the database too...
  auth = request.env['omniauth.auth']
  session[:provider] = auth['provider']
  session[:uid] = auth['uid']
  session[:nickname] = auth['info']['nickname']
  session[:token] = auth['credentials']['token']
  session[:secret] = auth['credentials']['secret']
  # this is the main endpoint to your application
  redirect to('/twitter/user')
end

get '/twitter/user' do
  @user = session[:nickname]
  @token = session[:token]
  @secret = session[:secret]
  timeline = open("https://api.twitter.com/1.1/statuses/user_timeline.json").read

  erb :tweets
end

get '/tweets' do
  uri = URI.parse("https://secure.com/")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(uri.request_uri, {
    'oauth_consumer_key' => 'HnLokC5vWkVC0r1HK4ojOQ',
    'oauth_nonce' => Oauth.nonce(), 
    #TODO  Add signature security via https://github.com/intridea/oauth2
    'oauth_signature_method' => '#####',
    'oauth_signature_method' => 'HMAC-SHA1', 
    'oauth_timestamp' => 'HnLokC5vWkVC0r1HK4ojOQ',
    'oauth_token' => '#{session[:token]}',    
    'oauth_version' => '1.0'
    })

  response = http.request(request)
  response.body
  response.status
  response["header-here"] # All headers are lowercase

  erb :tweets
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

#Ancillary secure pages from sinatra/bootstrap github repo
before '/secure/*' do
  if !session[:lastname] then
    session[:previous_url] = request.path
    @error = 'Sorry guacamole, you need to be logged in to visit ' + request.path
    halt erb(:checkin)
  end
end

get '/secure/place' do
  erb "This is a secret place that only <%=session[:identity]%> has access to!"
end
