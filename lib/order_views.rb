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
# Redirecting from successful charge 
get '/orders/:id' do
  @order = Order.find(params[:id])
  @items = LineItem.where(:order_id => @order.id)
  @venue = Venue.find(@order.venue_id)
  @customer = Customer.find(@order.customer_id)
  @charge = Stripe::Charge.retrieve(@order.stripe_id)
  erb :"order", :layout => (request.xhr? ? false : :layout)
end

# Get orders by venue
get "/:venue/orders" do
  @venue = params[:venue]
  @orders = Order.where(:venue => params[:venue]).order("created_at DESC").limit(30)
  erb :"venue/show", :layout => (request.xhr? ? false : :layout)
end

# Get orders by user(phone)
get "/user/:phone" do
  @orders = Order.where(:phone => params[:phone]).order("created_at DESC").limit(20)
  erb :"user/show", :layout => (request.xhr? ? false : :layout)
end

# Get orders by venue and location
get "/:venue/location/:location" do
  @venue = params[:venue]
  @location = params[:location]
  @orders = Order.where(:venue => params[:venue],:location => params[:location]).order("created_at DESC").limit(20)
  erb :"venue/location/show", :layout => (request.xhr? ? false : :layout)
end

#Shows all orders by all users
get '/' do
  @orders = Order.order("created_at DESC").limit(20)
  erb :"orders/index", :layout => (request.xhr? ? false : :layout)
end

post '/' do
  @orders = Order.order("created_at DESC").limit(20)
  erb :"orders/index", :layout => (request.xhr? ? false : :layout)
end