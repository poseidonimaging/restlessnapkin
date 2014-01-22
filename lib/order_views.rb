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

# Show item information(temporary after 1/21/14 db migration)
get '/admin/orders/item/:id' do
  @item = LineItem.find(params[:id])
  erb :"orders/item_edit"
end

# Update item information(temporary after 1/21/14 db migration)
put '/admin/orders/item/:id' do
  @item = LineItem.find(params[:id])
  @item.venue_id = params['venue']
  @item.customer_id = params['customer']
  if @item.save
    redirect "/admin/venue/dashboard"
  else
    erb "Item change was unsuccessful"
  end
end

# Get orders by venue
get "/:venue/orders" do
  @venue = Venue.find_by_handle(params[:venue])
  @orders = Order.where(:venue_id => @venue.id)
  @items = LineItem.include(:order, :customer, :venue)
  #@orders = Order.joins(:venue).where(:venues => {:handle => @venue.handle}).joins(:lineitem).where(:line_items => {:order_id => @orders.id})
  #@customer = Customer.joins(:order).where(:orders => {:customer_id => @orders.customer_id})
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