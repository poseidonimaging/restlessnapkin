# Add a menu item
get '/admin/:venue/food/add' do
  @venue = Venue.find_by_handle(params[:venue])
  erb :"/venue/food/add"
end

# Edit menu items
get '/admin/:venue/food/edit' do
  @venue = Venue.find_by_handle(params[:venue])
  @item = MenuItem.where(:venue_id => @venue.id)
  erb :"/venue/food/dashboard"
end

# Add a menu item via POST
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

# Show menu
get '/:venue/food/menu' do

  venue = Venue.find_by_handle(params[:venue])
  today_hours = OperatingTime.where(:venue_id => venue.id, :day_of_week => Time.now.wday)

  # putting this code up here temporarily
  @venue = Venue.find_by_handle(params[:venue])
  @item = MenuItem.where(:venue_id => @venue.id)
  erb :"chargeform"

# if venue is open
#  open = false
#  today_hours.each do |today_opt|
#    open = true if Time.now.hour >= today_opt.start_hour && Time.now.hour <= today_opt.end_hour 
#  end

# if venue.printer_active
#  if venue.printer_active
#    @venue = Venue.find_by_handle(params[:venue])
#    @item = MenuItem.where(:venue_id => @venue.id)
#    erb :"chargeform"
#  else
#    erb "<div class='alert alert-message'>#{venue.name} is not currently accepting online orders. Please reach out to us on twitter @dockandroll</div>"
#  end
end
