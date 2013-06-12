
require 'rubygems'
require 'sinatra'

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  enable :sessions
end

helpers do
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

before '/secure/*' do
  if !session[:identity] then
    session[:previous_url] = request.path
    @error = 'Sorry guacamole, you need to be logged in to visit ' + request.path
    halt erb(:checkin)
  end
end

get '/' do
  erb :checkin
end

get '/:venue/checkin/*' do 
  session[:venue] = params['venue']
  erb :checkin
end

post '/checkin/attempt' do
  session[:table] = params['table']
  session[:identity] = params['lastname']
  redirect '/drinkorder'
end

get '/checkout' do
  session.delete(:identity)
  erb "<div class='alert alert-success'>Your check will arrive shortly</div>"
end

post '/checkout' do
  session.delete(:identity)
  erb "<div class='alert alert-success'>Your check will arrive shortly</div>"
end

get '/drinkorder' do
  erb :drinkorder
end

post '/drinkorder' do
  erb :drinkorder
end

post '/confirm' do
  erb :confirm
end

get '/secure/place' do
  erb "This is a secret place that only <%=session[:identity]%> has access to!"
end
