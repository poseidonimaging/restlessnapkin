get '/admin/liquor/dashboard' do
  @gin = Liquor.by_type("gin")
  @rum = Liquor.by_type("rum")
  @tequila = Liquor.by_type("tequila")
  @vodka = Liquor.by_type("vodka")
  erb :"liquor/dashboard"
end

# Show all available liquors
get '/liquor/show' do
  @gin = Liquor.by_type("gin")
  @rum = Liquor.by_type("rum")
  @tequila = Liquor.by_type("tequila")
  @vodka = Liquor.by_type("vodka")
  erb :"liquor/show"
end

# Form to add liquor to db
get '/admin/liquor/add' do
  erb :"liquor/add"
end

# Add a liquor to db
post '/admin/liquor/add' do
  @liquor = Liquor.new
  @liquor.liquor_type = params[:liquor_type].downcase
  @liquor.name = params[:name]
  @liquor.description = params[:description]
  if @liquor.save
    redirect "/admin/liquor/dashboard"
  else
    erb :"/admin/dashboard"
  end
end

# Show venue by id
get '/liquor/:id' do
  @liquor = Liquor.find(params[:id])
  erb "#{@liquor.name} is a #{@liquor.liquor_type}"
end