#Looks at the venue and the phone number(splat), then shows form for checkin
get '/oontower/checkin/*' do 
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
  if Venue.exists?(:handle => params['venue'])
    session[:venue] = params['venue']
    @venue = Venue.find_by_handle(params['venue'])
    session[:phone] = params[:splat].first
    if session[:venue] && session[:phone]
      erb :checkin
    else
      erb "Something has gone awry. The napkin isn't saving the venue properly, please try again."
    end 
  else
    erb "We can't find that venue, please text the proper venue handle(no spaces like a twitter username)"
  end
end

# Get form for main menu drink order access
get '/orders/drinks' do
  if session[:venue] && session[:phone] && session[:firstname] && session[:lastname] && session[:location]
    @order = Order.new
    @venue = Venue.find_by_handle(session[:venue])
    @location = session[:location]
    @gin = Venue.find(@venue.id).liquors.by_type("gin")
    @rum = Venue.find(@venue.id).liquors.by_type("rum")
    @tequila = Venue.find(@venue.id).liquors.by_type("tequila")
    @vodka = Venue.find(@venue.id).liquors.by_type("vodka")
    erb :menu
  else
    erb "There has been a problem. Please click the link we last texted you to continue."
  end
end

# After checkin, shows form for drink order. Upon reordering, keeps session via lastname
post '/orders/drinks' do
  if session[:venue] #&& session[:phone]
    @order = Order.new
    session[:firstname] = params['firstname']
    session[:lastname] = params['lastname']
    session[:location] = params['location']
    @venue = Venue.find_by_handle(session[:venue])
    @location = session[:location]
    @gin = Venue.find(@venue.id).liquors.by_type("gin")
    @rum = Venue.find(@venue.id).liquors.by_type("rum")
    @tequila = Venue.find(@venue.id).liquors.by_type("tequila")
    @vodka = Venue.find(@venue.id).liquors.by_type("vodka")
    erb :menu
  else
    erb "There has been a problem. Please reclick the link we texted you to start over."
  end
end

# order menu sends POST request here
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
  @order.drinks_1 = "CLOSE TAB"
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