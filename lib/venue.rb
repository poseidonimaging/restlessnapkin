# Admin routes for venue specific management
# Show all venues
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
  @day_of_week = ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday']
  erb :"/venue/edit"
end

# Create or update venue hours to db
put '/admin/venue/hours/edit' do
  @venue = Venue.find(params[:venue_id])
  
  # Parse day of week data
  (0..6).each do |day|
    # Convert to military time if 'pm'
    #if params["#{day}_start_meridian"] = "pm" then
    #  start_hour = params["#{day}_start_hour"].to_i
    #  start_hour = start_hour + 12 unless start_hour = 12
    #else
    #  start_hour = params["#{day}_start_hour"].to_i
    #  start_hour = start_hour - 12 unless start_hour < 11
    #end

    #if params["#{day}_end_meridian"] = "pm" then
    #  end_hour = params["#{day}_end_hour"].to_i
    #  end_hour = end_hour - 12 unless end_hour = 12
    #else
    #  end_hour = params["#{day}_end_hour"].to_i
    #  end_hour = end_hour - 12 unless end_hour < 11
    #end

    end_meridian = params["#{day}_end_meridian"]
    end_hour = params["#{day}_end_hour"].to_i
    if end_meridian = "pm"
      end_hour = end_hour + 12
    end

    start_hour = params["#{day}_start_hour"].to_i

    @operating_time = OperatingTime.find_by_venue_id(@venue)
    @operating_time.venue_id = params[:venue_id]
    @operating_time.day_of_week = day
    @operating_time.start_hour = start_hour
    @operating_time.end_hour = end_hour
    if @operating_time.save
      redirect "/admin/venue/dashboard"
    else
      erb "<div class='alert alert-message'>Error saving Operating Time for #{@venue.name}</div>"
    end
  end

end

# Create or update venue hours to db
 post '/admin/venue/hours/edit' do
  @venue = Venue.find(params[:venue_id])
  
  # Parse day of week data
  (0..6).each do |day|
    # Convert to military time if 'pm'
    #if params["#{day}_start_meridian"] = "pm" then
    #  start_hour = params["#{day}_start_hour"].to_i
    #  start_hour = start_hour + 12 unless start_hour = 12
    #else
    #  start_hour = params["#{day}_start_hour"].to_i
    #  start_hour = start_hour - 12 unless start_hour < 11
    #end

    #if params["#{day}_end_meridian"] = "pm" then
    #  end_hour = params["#{day}_end_hour"].to_i
    #  end_hour = end_hour - 12 unless end_hour = 12
    #else
    #  end_hour = params["#{day}_end_hour"].to_i
    #  end_hour = end_hour - 12 unless end_hour < 11
    #end

    end_meridian = params["#{day}_end_meridian"]
    end_hour = params["#{day}_end_hour"].to_i
    if end_meridian = "pm"
      end_hour = end_hour + 12
    end

    start_hour = params["#{day}_start_hour"].to_i

    @operating_time = OperatingTime.new
    @operating_time.venue_id = params[:venue_id]
    @operating_time.day_of_week = day
    @operating_time.start_hour = start_hour
    @operating_time.end_hour = end_hour
    if @operating_time.save
      redirect "/admin/venue/dashboard"
    else
      erb "<div class='alert alert-message'>Error saving Operating Time for #{@venue.name}</div>"
    end
  end

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
# List of all venues
get '/venue/show' do
  @venue = Venue.order("created_at DESC")
  erb :"venue/show"
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