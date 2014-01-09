post '/charge' do
  # Amount in cents
  @amount = (params[:amount].to_i) * 100
  @customer_amount = @amount / 100

  # The order
  @venue = Venue.find(params[:venue])
  @customer_order = JSON.parse(params[:order].to_s) if params[:order]

  # Retrieve Stripe token
  @token = Stripe::Token.retrieve(params[:stripeToken])
  @customer_email = @token[:email]

  # Check to see if customer exists, else create new customer
  if Customer.exists?(:email => @customer_email)
    @customer = Customer.find_by_email(@customer_email)
    @stripe_customer = Stripe::Customer.retrieve(@customer.stripe_id)
  else
    @stripe_customer = Stripe::Customer.create(
      :email => @customer_email,
      :card  => params[:stripeToken]
    )
    @stripe_id = @stripe_customer.id

    # No Stripe customer existed, create a new one
    @customer = Customer.new
    @customer.email = @customer_email
    @customer.stripe_id = @stripe_id
    if @customer.save
      status 200 # OK
      { "success" => true }.to_json
    else
      status 422 # Unprocessable Entity
      { "success" => false }.to_json
    end
  end

  # Write order to the database
  @order = Order.new
  @order.venue_id = @venue
  @order.customer_id = @customer.id

  # Loop each line item
  x = 1
  @customer_order.each do |item|
    line_item = "item_#{x}"
    @order.line_item = item["quantity"] 'x' item["item"]
    x += 1
  end

  # If writing to db is successful, execute charge
  if @order.save
    status 200 # OK
    { "success" => true }.to_json

    charge = Stripe::Charge.create(
      :amount      => @amount,
      :description => @venue,
      :currency    => 'usd',
      :customer    => @stripe_customer.id
    )
  else
    status 422 # Unprocessable Entity
    { "success" => false }.to_json
  end

  # Print the order
  if @customer_order
    printer_erb = ERB.new(File.read(File.join(File.dirname(__FILE__), "views", "printer", "order.erb")))
    printer = Mprinter.new("529f7338449aa8a96b00001a")
    printer_html = printer_erb.result(binding)
    puts printer_html.inspect
    puts printer.print(printer_html).body
  end

  erb :charge
end

error Stripe::CardError do
  env['sinatra.error'].message
end