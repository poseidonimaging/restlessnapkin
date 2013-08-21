#Looks at the venue and the phone number(splat), then shows form for checkin
get '/moontower/checkin/*' do 
  session[:venue] = 'moontower'
  session[:phone] = params[:splat].first
  #session[:phone_short] = session[:phone].[-4..-1]
  if session[:venue] && session[:phone]
    erb :"/moontower/checkin"
  else
    erb "Something went awry. Please try again and make sure you texted the venue's name properly."
  end
end

#Looks at the venue and the phone number(splat), then shows form for checkin
get '/:venue/checkin/*' do 
  session[:venue] = params['venue']
  session[:phone] = params[:splat].first
  if session[:venue] && session[:phone]
    erb :"/checkin"
  else
    erb "Something went awry. Please try again and make sure you texted the venue's name properly."
  end
end

# Get form for main menu drink order access
get '/orders/drinks' do
  if session[:venue] && session[:phone] && session[:firstname] && session[:lastname] && session[:location]
    @order = Order.new
    erb :"orders/drinks"
  elsif session[:venue] && session[:phone]
    @order = Order.new
    session[:firstname] = params['firstname']
    session[:lastname] = params['lastname']
    session[:location] = params['location']
    erb :menu
  else
    erb "There has been a problem. Please click the link we last texted you to continue."
  end
end

# After checkin, shows form for drink order. Upon reordering, keeps session via lastname
post '/orders/drinks' do
  if session[:venue] && session[:phone] && session[:firstname] && session[:lastname] && session[:location]
    @order = Order.new
    erb :"orders/drinks"
  elsif
    session[:venue] && session[:phone]
    @order = Order.new
    session[:firstname] = params['firstname']
    session[:lastname] = params['lastname']
    session[:location] = params['location']
    erb :"orders/drinks"
  else
    erb "There has been a problem. Please reclick the link we texted you to start over."
  end
end

# venue drink menu (needs venue/menu)
get "/:venue/menu" do
  @venue = Venue.find_by_handle(params[:venue])
  @location = session[:location]
  @gin = Venue.find(@venue.id).liquors.by_type("gin")
  @rum = Venue.find(@venue.id).liquors.by_type("rum")
  @tequila = Venue.find(@venue.id).liquors.by_type("tequila")
  @vodka = Venue.find(@venue.id).liquors.by_type("vodka")
  erb :menu, :layout => (request.xhr? ? false : :layout)
end

# drink menu
get "/menu" do
  @gin = Venue.find(1).liquors.by_type("gin")
  @rum = Venue.find(1).liquors.by_type("rum")
  @tequila = Venue.find(1).liquors.by_type("tequila")
  @vodka = Venue.find(1).liquors.by_type("vodka")
  #@whisky = Venue.find(1).liquors.by_type("whisky")
  erb :menu, :layout => (request.xhr? ? false : :layout)
end

# New order form sends POST request here
post '/orders' do
  @order = Order.new(params[:order])
  @order.venue = session[:venue]
  @order.location = session[:location]
  @order.firstname = session[:firstname]
  @order.lastname = session[:lastname]
  @order.phone = session[:phone]
  if @order.save
    redirect "/orders/#{@order.id}"
  else
    erb :"orders/drinks"
  end
end

# Provides next step options to user after order
get '/orders/confirm' do
  erb :"orders/confirm"
end

# Change location
get "/location/change" do
  erb :"location/change"
end

# Confirm location change
post "/location/confirm" do
  session[:location] = params['location']
  @orders = Order.where(:phone => session[:phone]).order("created_at DESC").limit(20)
  erb :"location/confirm", :layout => (request.xhr? ? false : :layout)
end

#User checkout of venue
get '/checkout' do
  @location = session[:location]
  erb :checkout
end

#User checkout of venue
post '/checkout' do
  @order = Order.new
  @order.drinks = "CLOSE TAB"
  @order.venue = session[:venue]
  @order.location = session[:location]
  @order.firstname = session[:firstname]
  @order.lastname = session[:lastname]
  @order.phone = session[:phone]
  if @order.save
    session.delete(:lastname)
    redirect "/orders/#{@order.id}"
  else
    erb "Checkout was unsuccessful"
  end
end

get '/:venue/status' do
  @venue = Venue.where(:handle => params[:venue]).first
  erb :status

end