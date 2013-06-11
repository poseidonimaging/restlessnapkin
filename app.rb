
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
    halt erb(:login_form)
  end
end

get '/' do
  erb :checkin
end

get '/:venue/checkin' do 
  session[:venue] = params['venue']
  erb :login_form
end

post '/checkin/attempt' do
  session[:table] = params['table']
  session[:identity] = params['username']
  #where_user_came_from = session[:previous_url] || '/'
  redirect '/drinkorder'
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Your check will arrive shortly</div>"
end

#post '/checkin' do
#  @venue = params['venue']
#  erb :drinkorder
#end

get '/drinkorder' do
  erb :drinkorder
end

#post '/:venue/:table' do
#  @venue = params[:venue]
#  @table = params[:table]
#  erb :drinkorder
#end

post '/confirm' do
  erb :confirm
end

get '/secure/place' do
  erb "This is a secret place that only <%=session[:identity]%> has access to!"
end
