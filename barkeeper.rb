# Barkeeper orders that need attention
get '/barkeeper' do
  @orders = Order.where(:fulfilled_at => nil).limit(10)
  erb :barkeeper, :layout => (request.xhr? ? false : :layout)
end

get '/moontower-barkeeper' do
  @orders = Order.where(:fulfilled_at => nil, :venue => "moontower").limit(10)
  erb :moontower, :layout => (request.xhr? ? false : :layout)
end

# Put where received_at's go
put '/orders/received/:id' do
  content_type :json
  @order = Order.find(params[:id])
  @order.received_at = Time.now
  if @order.save
    status 200 # OK
    { "success" => true }.to_json
  else
    status 422 # Unprocessable Entity
    { "success" => false }.to_json
  end
end

# Put where fulfilled_at's go
put '/orders/fulfilled/:id' do
  content_type :json
  @order = Order.find(params[:id])
  @order.fulfilled_at = Time.now
  if @order.save
    status 200 # OK
    { "success" => true }.to_json
  else
    status 422 # Unprocessable Entity
    { "success" => false }.to_json
  end
end