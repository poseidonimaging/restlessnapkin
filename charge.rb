# Test charge
get '/test/:venue/food/menu' do
  @venue = Venue.find_by_handle(params[:venue])
  @item = MenuItem.where(:venue_id => @venue.id)
  erb :chargeform
end

# Add a menu item
get '/admin/:venue/food/add' do
  @venue = Venue.find_by_handle(params[:venue])
  erb :"/food/add"
end