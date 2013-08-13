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
get '/orders/:id' do
  @order = Order.find(params[:id])
  erb :"orders/show", :layout => (request.xhr? ? false : :layout)
end

# Get orders by venue
get "/venue/:venue" do
  @venue = params[:venue]
  @orders = Order.where(:venue => params[:venue]).order("created_at DESC").limit(30)
  erb :"venue/show", :layout => (request.xhr? ? false : :layout)
end

# Get orders by user(phone)
get "/user/:phone" do
  @orders = Order.where(:phone => params[:phone]).order("created_at DESC").limit(20)
  erb :"user/show", :layout => (request.xhr? ? false : :layout)
end

# Get orders by venue and table
get "/venue/:venue/table/:table" do
  @venue = params[:venue]
  @table = params[:table]
  @orders = Order.where(:venue => params[:venue],:table => params[:table]).order("created_at DESC").limit(20)
  erb :"venue/table/show", :layout => (request.xhr? ? false : :layout)
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