
require 'rubygems'
require 'sinatra'
require 'sinatra/activerecord'

set :database, "sqlite3:///orders.db"

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
  erb :"orders/checkin"
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
    redirect "/confirm"
  else
    erb :"orders/drinks"
  end
end

# Get individual orders
#get "/orders/:id" do
#  @order = Order.find(params[:id])
#  erb :"orders/show"
#end

#Get orders by user's table
get "/orders/:venue" do
  @order = Order.find(params[:venue])
  erb :"orders/table"
end

# Provides next step options to user after order
get '/confirm' do
  erb :"/confirm"
end

# Showing all orders via confirm screen
post '/orders/index' do
  @orders = Order.order("created_at DESC")
  erb :"orders/index"
end

#User checkout of venue
get '/checkout' do
  session.delete(:lastname)
  erb "<div class='alert alert-success'>Your check will arrive shortly</div>"
end

#User checkout of venue
post '/checkout' do
  session.delete(:lastname)
  erb "<div class='alert alert-success'>Your check will arrive shortly</div>"
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
