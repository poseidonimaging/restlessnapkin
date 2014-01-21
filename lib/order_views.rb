# Showing all orders via main menu
get '/orders' do
  @orders = Order.order("created_at DESC")
  @items = LineItem.where(:order_id => @orders.id)
  @venue = Venue.where(:venue_id => @orders.venue_id)
  @customer = Customer.where(:customer_id => @orders.customer_id)
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
  @venue = Venue.find_by_handle(params[:venue])
  @orders = Order.joins(:venue).where(:venues => {:handle => @venue.handle})
  @items = Order.joins("LEFT OUTER JOIN line_items ON orders.id = line_items.order_id").where(:orders => {:id => @orders.id})
  @customer = Customer.joins(:order).where(:orders => {:customer_id => @orders.customer_id})
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
get '/orders/all' do
  @orders = Order.order("created_at DESC").limit(20)
  erb :"orders/index", :layout => (request.xhr? ? false : :layout)
end

post '/' do
  @orders = Order.order("created_at DESC").limit(20)
  erb :"orders/index", :layout => (request.xhr? ? false : :layout)
end