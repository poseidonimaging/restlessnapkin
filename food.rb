# Edit menu items
get '/admin/:venue/food/edit' do
  @venue = Venue.find_by_handle(params[:venue])
  @item = MenuItem.where(:venue_id => @venue.id)
  erb :"/food/dashboard"
end

# Add a menu item
post '/admin/food/add' do
  @venue = params[:venue]
  @item = MenuItem.new
  @item.name = params[:name]
  @item.description = params[:description]
  @item.price = params[:price]
  @item.venue_id = params[:venue_id]
  if @item.save
    redirect "/admin/#{@venue}/food/edit"
  else
    erb :"/admin/dashboard"
  end
end

# Add a menu item
get '/admin/:venue/food/add' do
  @venue = Venue.find_by_handle(params[:venue])
  erb :"/food/add"
end