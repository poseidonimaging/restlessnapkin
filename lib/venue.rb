get '/admin/venue/dashboard' do
  @venue = Venue.order("created_at DESC")
  erb :"venue/dashboard"
end

get '/venue/show' do
  @venue = Venue.order("created_at DESC")
  erb :"venue/show"
end

# Show venue by id
get '/venue/:id' do
  @venue = Venue.find(params[:id])
  erb "The venue is called #{@venue.name} and its handle is #{@venue.handle}"
end

# Form to add a venue to db
get '/admin/venue/add' do
  erb :"/venue/add"
end

# Add a venue
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