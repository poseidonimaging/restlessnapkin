
require 'rubygems'
require 'sinatra'

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello Stranger'
  end
end

before '/secure/*' do
  if !session[:identity] then
    session[:previous_url] = request.path
    @error = 'Sorry guacamole, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
  erb :checkin
end

#post '/checkin' do
#  @venue = params['venue']
#  erb :drinkorder
#end

get '/venue/:venue' do
  @venue = "#{params[:venue]}"
  erb :drinkorder
end

#post '/orderconfirm' do
#  erb :order_confirm
#end

get '/checkin/:venue' do 
  erb :login_form
end

post '/checkin/attempt' do
  @firstname = params['firstname']
  @lastname = params['username']
  @table = params['table']
  session[:identity] = params['username']
  #where_user_came_from = session[:previous_url] || '/'
  redirect '/venue/219west'
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Your check will arrive shortly</div>"
end


get '/secure/place' do
  erb "This is a secret place that only <%=session[:identity]%> has access to!"
end
