# Admin dashboard - all individual functionality in appropriate rb file
before '/admin/*' do
  if !session[:admin] then
    session[:previous_url] = request.path
    @error = 'Sorry guacamole, you need to be logged in to visit ' + request.path
    halt erb(:"admin/login")
  end
end

get '/admin/login' do 
  erb :"/admin/login"
end

post '/login/attempt' do
  if params[:password] == 'wizard'
    session[:admin] = 'admin'
    redirect '/admin/dashboard'
  else
    redirect '/admin/login'
  end
end

get '/logout' do
  session.delete(:admin)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/admin/dashboard' do
  erb :"/admin/dashboard"
end
