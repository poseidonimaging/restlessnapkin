
require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'
require 'open-uri'
require 'uri'

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
end

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  enable :sessions
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
end

#before '/*/*' do
#  if !session[:lastname] then
#    session[:previous_url] = request.path
#    erb(:checkin_alert)
#  end
#end

#Shows all orders by all users
get '/' do
  @orders = Order.order("created_at DESC")
  erb :"orders/index"
end

post '/' do
  @orders = Order.order("created_at DESC")
  erb :"orders/index"
end

#Looks at the venue and the phone number(splat), then shows form for checkin
get '/:venue/checkin/*' do 
  session[:venue] = params['venue']
  session[:phone] = params[:splat]
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
    erb :"orders/drinks"
  end
end

# After checkin, shows form for drink order. Upon reordering, keeps session via lastname
post '/orders/drinks' do
  if session[:lastname]
    @order = Order.new
    erb :"orders/drinks"
  else
    @order = Order.new
    session[:lastname] = params['lastname']
    session[:firstname] = params['firstname']
    session[:table] = params['table']
    erb :"orders/drinks"
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
  erb :"orders/index"
end

# Showing all orders via confirm screen
post '/orders/index' do
  @orders = Order.order("created_at DESC")
  erb :"orders/index"
end

# Get individual orders
get "/orders/:id" do
  @order = Order.find(params[:id])
  erb :"orders/show"
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
