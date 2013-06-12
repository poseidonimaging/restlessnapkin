
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
    session[:identity] ? session[:identity] : 'Hello Stranger'
  end
  
  def venue
    session[:venue] ? session[:venue] : 'No Venue'
  end

  def table
    session[:table] ? session[:table] : 'No Table'
  end
end

get '/' do
  @orders = Order.order("created_at DESC")
  erb :"orders/index"
end

get '/:venue/checkin/*' do 
  session[:venue] = params['venue']
  session[:phone] = params[:splat]
  erb :"orders/checkin"
end

post '/checkin/attempt' do
  session[:firstname] = params['firstname']
  session[:identity] = params['lastname']
  session[:table] = params['table']
  
  redirect '/orders/drinks'
end

# Get the New Order form
get '/orders/drinks' do
  @order = Order.new
  erb :"orders/drinks"
end

# New Order form sends POST request here
post '/orders' do
  @order = Order.new(params[:order])
  if @order.save
    redirect "order/#{@order.id}"
  else
    erb :"orders/drinks"
  end
end

# Get individual orders
get "/orders/:id" do
  @order = Order.find(params[:id])
  @lastname = @order.lastname
  erb :"orders/show"
end

post '/confirm' do
  erb :"orders/confirm"
end

get '/checkout' do
  session.delete(:identity)
  erb "<div class='alert alert-success'>Your check will arrive shortly</div>"
end

post '/checkout' do
  session.delete(:identity)
  erb "<div class='alert alert-success'>Your check will arrive shortly</div>"
end

before '/secure/*' do
  if !session[:identity] then
    session[:previous_url] = request.path
    @error = 'Sorry guacamole, you need to be logged in to visit ' + request.path
    halt erb(:checkin)
  end
end

get '/secure/place' do
  erb "This is a secret place that only <%=session[:identity]%> has access to!"
end
