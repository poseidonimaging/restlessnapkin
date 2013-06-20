
require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'newrelic_rpm'
require 'open-uri'
require 'uri'

#require 'twilio-ruby'
#phone_number = '+15128616050'
#Twilio::REST::Client.new(ACc3d70d00cdb2818a1ea2564283aeffce,35583e7b60273fbd9560991dd0969860)

configure :development do
  set :database, "sqlite3:///orders.db"
end

configure :production do
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :port     => db.port,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
end

class Order < ActiveRecord::Base
  validates :venue, presence: true, length: { minimum: 3}
  validates :table, presence: true, length: { minimum: 1}
  validates :lastname, presence: true, length: { minimum: 2}
  validates :phone, presence: true, length: { minimum: 10}
  validates :drinks, presence: true, length: { minimum: 5}
end

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  enable :sessions
  set :session_secret, 'H65uT0A4s9uY41w3'
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

#before do
#    content_type 'application/json'
#end

#Shows all orders by all users
get '/' do
  @orders = Order.order("created_at DESC").limit(20)
  erb :"orders/index", :layout => (request.xhr? ? false : :layout)
end

post '/' do
  @orders = Order.order("created_at DESC").limit(20)
  erb :"orders/index", :layout => (request.xhr? ? false : :layout)
end

#Looks at the venue and the phone number(splat), then shows form for checkin
get '/:venue/checkin/*' do 
  session[:venue] = params['venue']
  session[:phone] = params[:splat].first
  erb :"/checkin"
end

# Get form for main menu drink order access
get '/orders/drinks' do
  if session[:lastname]
    @order = Order.new
    erb :"orders/drinks"
  else
    @order = Order.new
    session[:lastname] = params['lastname']
    session[:firstname] = params['firstname']
    session[:table] = params['table']
    erb :"orders/drinks", :layout => (request.xhr? ? false : :layout)
  end
end

# After checkin, shows form for drink order. Upon reordering, keeps session via lastname
post '/orders/drinks' do
  if session[:lastname]
    @order = Order.new
    erb :"orders/drinks"
  else
    erb "There has been an error saving your checkin information. Please try again later."
  end
end

# New order form sends POST request here
post '/orders' do
  @order = Order.new(params[:order])
  @order.venue = session[:venue]
  @order.table = session[:table]
  @order.firstname = session[:firstname]
  @order.lastname = session[:lastname]
  @order.phone = session[:phone]
  if @order.save
    redirect "/orders/confirm"
  else
    erb :"orders/drinks"
  end
end

#Get orders by user's table
#get "/orders/:venue" do
#  @order = Order.find(params[:venue])
#  erb :"orders/table"
#end

# Provides next step options to user after order
get '/orders/confirm' do
  erb :"orders/confirm"
end

# Table change via main menu
get '/table/change' do
  erb :"table/change"
end

# Provides next step options to user after table change
post '/table/change' do
  erb :"table/change"
end

# Provides next step options to user after table change
post '/table/confirm' do
  session[:table] = params['table']
  erb :"table/confirm"
end

# Showing all orders via main menu
get '/orders/index' do
  @orders = Order.order("created_at DESC")
  erb :"orders/index", :layout => (request.xhr? ? false : :layout)
end

# Showing all orders via confirm screen
post '/orders/index' do
  @orders = Order.order("created_at DESC")
  erb :"orders/index", :layout => (request.xhr? ? false : :layout)
end

# Get individual orders
get "/orders/:id" do
  @order = Order.find(params[:id])
  erb :"orders/show"
end

# Get orders by venue
get "/venue/:venue" do
  @venue = params[:venue]
  @orders = Order.where(:venue => params[:venue]).order("created_at DESC").limit(20)
  erb :"venue/show", :layout => (request.xhr? ? false : :layout)
end

# Get orders by user(phone)
get "/user/:phone" do
  @orders = Order.where(:phone => params[:phone]).order("created_at DESC").limit(20)
  erb :"user/show", :layout => (request.xhr? ? false : :layout)
end

# Get orders by venue and table
get "/venue/:venue/table/:table" do
  @venue = params[:venue]
  @table = params[:table]
  @orders = Order.where(:venue => params[:venue],:table => params[:table]).order("created_at DESC").limit(20)
  erb :"venue/table/show", :layout => (request.xhr? ? false : :layout)
end

#User checkout of venue
get '/checkout' do
  session.delete(:lastname)
  erb :checkout
end

#User checkout of venue
post '/checkout' do
  session.delete(:lastname)
  erb :checkout
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
