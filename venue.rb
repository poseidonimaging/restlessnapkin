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

# Show liquors by venue
get '/:venue/liquor' do
  @venue = Venue.find_by_handle(params[:venue])
  @gin = Venue.find(@venue.id).liquors.by_type("gin")
  @rum = Venue.find(@venue.id).liquors.by_type("rum")
  @tequila = Venue.find(@venue.id).liquors.by_type("tequila")
  @vodka = Venue.find(@venue.id).liquors.by_type("vodka")
  erb :"/venue/liquor"
end

# Edit which liquors are available at each venue
get '/admin/:venue/liquor/edit' do
  @venue = Venue.find_by_handle(params[:venue])
  @liquor_venue = Liquor.joins(:venue).where(:venues => {:id => '<%= @venue.id %>'})
  @gin = Liquor.by_type("gin")
  @rum = Liquor.by_type("rum")
  @tequila = Liquor.by_type("tequila")
  @vodka = Liquor.by_type("vodka")
  erb :"/venue/liquor/edit"
end

# Add a liquor to a venue
#post '/admin/venue/:id' do
#  @venue = Venue.find(params[:id])
#  erb "The venue is called #{@venue.name} and its handle is #{@venue.handle}"
#end