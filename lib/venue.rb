# Admin routes for venue specific management
# Show all venues
get '/admin/venue' do
  redirect "/admin/venue/dashboard"
end

get '/admin/venue/dashboard' do
  @venue = Venue.order("created_at DESC")
  erb :"/venue/dashboard"
end

# Add a venue form
get '/admin/venue/add' do
  erb :"/venue/add"
end

# Add a venue to db
post '/admin/venue/add' do
  @venue = Venue.new
  @venue.name = params[:name]
  @venue.handle = params[:handle]
  if @venue.save
    redirect "/admin/venue/dashboard"
  else
    erb :"/admin/dashboard"
  end
end

# Edit venue information
get '/admin/:venue/edit' do
  @venue = Venue.find_by_handle(params[:venue])
  erb :"/venue/edit"
end

# Update venue information
put '/admin/venue/edit' do
  @venue = Venue.find(params[:venue_id])
  @venue.name = params[:name]
  @venue.handle = params[:handle]
  @venue.phone = params[:phone]
  @venue.printer_id = params[:printer_id]
  @venue.address = params[:address]
  @venue.city = params[:city]
  @venue.state = params[:state]
  @venue.postal_code = params[:postal_code].upcase 
  if @venue.save
    redirect "/admin/venue/dashboard"
  else
    redirect "/admin/#{@venue.name}/edit"
  end
end

# Printer active or inactive
get '/admin/:venue/printer/edit' do
  @venue = Venue.find_by_handle(params[:venue])
  @venue.printer_active = params[:printer_active]
  erb :"/venue/printer/edit"
end

# Printer active or inactive
put '/admin/venue/printer/edit' do
  @venue = Venue.find(params[:venue_id])
  @venue.printer_active = params[:printer_active]
  if @venue.save
    redirect "/admin/venue/dashboard"
  else
    redirect "/admin/#{@venue.name}/edit"
  end
end

# Edit venue hours of operation
get '/admin/:venue/hours/edit' do
  @venue = Venue.find_by_handle(params[:venue])
  @time = OperatingTime.where(:venue_id => @venue.id)
  @day_of_week = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday']
  erb :"/venue/hours/edit"
end

# Update venue hours to db
put '/admin/venue/hours/edit' do
  @venue = Venue.find(params[:venue_id])
  
  # Parse day of week data and write to db
  params[:id].each do |day|
    # Convert to military time if 'pm'
    end_meridian = params["#{day}_end_meridian"]
    end_hour = params["#{day}_end_hour"].to_i
    if end_meridian == "pm"
      end_hour = end_hour + 12
    end

    start_hour = params["#{day}_start_hour"].to_i

    @operating_time = OperatingTime.find_by_venue_id(@venue)
    @operating_time.venue_id = params[:venue_id]
    @operating_time.day_of_week = day
    @operating_time.start_hour = start_hour
    @operating_time.end_hour = end_hour
    if @operating_time.save
      status 200 # OK
      { "success" => true }.to_json
    else
      status 422 # Unprocessable Entity
      { "success" => false }.to_json
    end
  end
  redirect "/admin/venue/dashboard"
end

# This is the one that works 1/8/14
# Create venue hours to db
 post '/admin/venue/hours/add' do
  @venue = Venue.find(params[:venue_id])
  
  # Parse day of week data and write to db
  (0..6).each do |day|
    # Convert to military time if 'pm'
    end_meridian = params["#{day}_end_meridian"]
    end_hour = params["#{day}_end_hour"].to_i
    if end_meridian == "pm"
      end_hour = end_hour + 12
    end

    start_hour = params["#{day}_start_hour"].to_i

    @operating_time = OperatingTime.new
    @operating_time.venue_id = params[:venue_id]
    @operating_time.day_of_week = day
    @operating_time.start_hour = start_hour
    @operating_time.end_hour = end_hour
    if @operating_time.save
      status 200 # OK
      { "success" => true }.to_json
    else
      status 422 # Unprocessable Entity
      { "success" => false }.to_json
    end
  end
  redirect "/admin/venue/dashboard"
end

# Edit which liquors are available per venue
get '/admin/:venue/liquor/edit' do
  @venue = Venue.find_by_handle(params[:venue])
  @liquor = Venue.find(@venue.id).liquors_venues.where(:venue_id => @venue.id)
  @liquors_venue = @liquor.map { |liquor| liquor.liquor_id }
  @gin = Liquor.by_type("gin")
  @rum = Liquor.by_type("rum")
  @tequila = Liquor.by_type("tequila")
  @vodka = Liquor.by_type("vodka")
  erb :"/venue/liquor/edit"
end


# Begin non-admin venue routes
# Stripe setup routes

# Stripe authorization
get '/venue/authorize' do
  erb :"/venue/stripe/authorize"
end

# Stripe authorization callback
get '/venue/callback' do
  
  # Pull the authorization code out of the response
  @code = params[:code]

  # Make a request to the access_token_uri endpoint to get an access_token
  #@resp = settings.client.auth_code.get_token(code, :params => {:scope => 'read_write'})
  #@access_token = @resp.token

  erb :"/venue/stripe/callback"
end

# List of all venues
get '/venue/show' do
  @venue = Venue.order("created_at DESC")
  erb :"/venue/show"
end

# Show venue by id
get '/venue/:id' do
  @venue = Venue.find(params[:id])
  erb "The venue is called #{@venue.name} and its handle is #{@venue.handle}"
end

# Show liquors by venue
get '/:venue/liquor' do
  @venue = Venue.find_by_handle(params[:venue])
  @gin = Venue.find(@venue.id).liquors.by_type("gin")
  @rum = Venue.find(@venue.id).liquors.by_type("rum")
  @tequila = Venue.find(@venue.id).liquors.by_type("tequila")
  @vodka = Venue.find(@venue.id).liquors.by_type("vodka")
  erb :"/venue/liquor"
end

#Add a liquor to a venue
post '/liquor/checked/:id' do
  content_type :json
  @liquors_venue = LiquorsVenue.new
  @liquors_venue.liquor_id = params[:id]
  @liquors_venue.venue_id = params[:venue]
  @liquors_venue.well = false
  if @liquors_venue.save
    status 200 # OK
    { "success" => true }.to_json
  else
    status 422 # Unprocessable Entity
    { "success" => false }.to_json
  end
end

#Add a liquor to a venue
delete '/liquor/unchecked/:id' do
  content_type :json
  @liquors_venue = LiquorsVenue.find_by_liquor_id(params[:id]).destroy
  if @liquors_venue.destroy
    status 200 # OK
    { "success" => true }.to_json
  else
    status 422 # Unprocessable Entity
    { "success" => false }.to_json
  end
end