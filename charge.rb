post '/charge' do
  # Amount in cents
  @amount = params[:amount].to_i
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

  # Write order to the Order
  @order = Order.new
  @order.venue_id = @venue.id
  @order.customer_id = @customer.id
  if @order.save
    status 200 # OK
    { "success" => true }.to_json

    # Write line items to LineItem
    @customer_order.each do |item|
      @line_item = LineItem.new
      @line_item.order_id = @order.id
      @line_item.quantity = item["quantity"]
      @line_item.item = item["item"]
      if @line_item.save
        status 200 # OK
        { "success" => true }.to_json
      else
        status 422 # Unprocessable Entity
        { "success" => false }.to_json
      end
    end
  else
    status 422 # Unprocessable Entity
    { "success" => false }.to_json
  end

  # If writing to db is successful, execute charge
  if @order.save
    status 200 # OK
    { "success" => true }.to_json

    @charge = Stripe::Charge.create(
      :amount      => @amount,
      :description => @venue.name,
      :currency    => 'usd',
      :customer    => @stripe_customer.id
    )
    @order.stripe_id = @charge.id
    if @order.save
      status 200 # OK
      { "success" => true }.to_json
    else
    status 422 # Unprocessable Entity
    { "success" => false }.to_json
    end
  else
    status 422 # Unprocessable Entity
    { "success" => false }.to_json
  end

  # Print the order
  if @customer_order
    printer_erb = ERB.new(File.read(File.join(File.dirname(__FILE__), "views", "printer", "order.erb")))
    printer = Mprinter.new(@venue.printer_id)
    printer_html = printer_erb.result(binding)

    # 4/2/14 Take response print id and place it in database for retreival
    #@order.item_1 = @response.id
    
    puts printer_html.inspect

    session[:print_response] = printer.print(printer_html).body
    puts session[:print_response]
    
  end

  redirect "/orders/#{@order.id}"
end

error Stripe::CardError do
  env['sinatra.error'].message
end