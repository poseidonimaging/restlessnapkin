
require "rubygems"
require "sinatra"
require "sinatra/activerecord"
require "newrelic_rpm"
require "open-uri"
require "uri"
require "json"
#require "oauth2"
require "omniauth"
require "omniauth-twitter"
require "omniauth-oauth2"
require "./models"
load "./orderviews.rb"
load "./userorders.rb"
load "./barkeeper.rb"

#require 'twilio-ruby'
#phone_number = '+15128616050'
#Twilio::REST::Client.new(ACc3d70d00cdb2818a1ea2564283aeffce,35583e7b60273fbd9560991dd0969860)

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
  # db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

  # ActiveRecord::Base.establish_connection(
  #   :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  #   :host     => db.host,
  #   :port     => db.port,
  #   :username => db.user,
  #   :password => db.password,
  #   :database => db.path[1..-1],
  #   :encoding => 'utf8'
  # )

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

  def table
    session[:table] ? session[:table] : 'No Table'
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
  #provider :mprinter, 'Ehfv3Qk44jJiB8bifM3A','g91EciYab2LdB83eKaRm', callback_url => (ENV['https://manage.themprinter.com/api/v1/'])
  provider :twitter, 'HnLokC5vWkVC0r1HK4ojOQ', 'WmGe0dWFNvLrtl06Gon4Y6LuVv6UBm57kjyVWXtNjNY'
  #provider :att, 'client_id', 'client_secret', :callback_url => (ENV['BASE_DOMAIN']
end


#before do
  # we do not want to redirect to twitter when the path info starts
  # with /auth/
  #pass if request.path_info =~ /^\/auth\//

  # /auth/twitter is captured by omniauth:
  # when the path info matches /auth/twitter, omniauth will redirect to twitter
  #redirect to('/auth/twitter') unless current_user
#end

# Support both GET and POST for OAuth callbacks
#%w(get post).each do |method|
#  send(method, "/auth/:provider/callback") do
#    env['omniauth.auth'] # => OmniAuth::AuthHash
#  end
#end

get '/auth/twitter/callback' do
  # probably you will need to create a user in the database too...
  session[:uid] = env['omniauth.auth']['uid']
  # this is the main endpoint to your application
  redirect to('/')
end

get '/twitter' do
  erb "<a href='/auth/twitter'>Sign in with Twitter</a>"
end

# Support for OAuth failure
get '/auth/failure' do
  flash[:notice] = params[:message] # if using sinatra-flash or rack-flash
  redirect '/'
end

get '/example.json' do
  content_type :json
  { :key1 => 'value1', :key2 => 'value2' }.to_json
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
