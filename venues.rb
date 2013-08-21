# Showing all orders via main menu
get '/venue/add' do
  #@venue = Venue.new
  erb :"/venue/add_venue"
end

# POST for adding a venue
post '/venue/add' do
  @venue = Venue.new
  @venue.name = params[:name]
  @venue.handle = params[:handle]
  if @venue.save
    redirect "/venue/#{@venue.id}"
  else
    erb :"/venue/add_venue"
  end
end

# Show venue by id
get '/venue/:id' do
  @venue = Venue.find(params[:id])
  erb "The venue is called #{@venue.name} and its handle is #{@venue.handle}"
end