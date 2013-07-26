
require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'newrelic_rpm'
require 'open-uri'
require 'uri'
require "json"
require 'oauth2'
require "./models"
require "./orderviews"
require "./userorders"
require "./barkeeper"

#require 'twilio-ruby'
#phone_number = '+15128616050'
#Twilio::REST::Client.new(ACc3d70d00cdb2818a1ea2564283aeffce,35583e7b60273fbd9560991dd0969860)

# printer OAuth configuration
client = OAuth2::Client.new('Ehfv3Qk44jJiB8bifM3A', 'g91EciYab2LdB83eKaRm', :site => 'https://manage.themprinter.com/api/v1/')

client.auth_code.authorize_url(:redirect_uri => 'http://localhost:8080/oauth2/callback')
# => "https://example.org/oauth/authorization?response_type=code&client_id=client_id&redirect_uri=http://localhost:8080/oauth2/callback"

token = client.auth_code.get_token('authorization_code_value', :redirect_uri => 'http://localhost:8080/oauth2/callback', :headers => {'Authorization' => 'Basic some_password'})
response = token.get('/api/resource', :params => { 'query_foo' => 'bar' })
response.class.name
# => OAuth2::Response

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  enable :sessions
  set :session_secret, "nPiOpaoyqcyeaABv2huEqlvZw6CxkC0Qo71hMlbwMbhmzWAjcndLD5piz9PqXt8"
  set :method_override, true
end

configure :development do
  set :database, "sqlite3:///orders.db"
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
