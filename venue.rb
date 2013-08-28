get '/admin/venue/dashboard' do
  @venue = Venue.order("created_at DESC")
  erb :"venue/dashboard"
end

get '/venue/show' do
  @venue = Venue.order("created_at DESC")
  erb :"venue/show"
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

# Show venue by id
get '/venue/:id' do
  @venue = Venue.find(params[:id])
  erb "The venue is called #{@venue.name} and its handle is #{@venue.handle}"
end

# Edit which liquors are available at each venue
# get '/:venue/liquor'

# Add a liquor to a venue
#post '/admin/venue/:id' do
#  @venue = Venue.find(params[:id])
#  erb "The venue is called #{@venue.name} and its handle is #{@venue.handle}"
#end