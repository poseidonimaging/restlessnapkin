post '/charge' do
  # Amount in cents
  @amount = (params[:amount].to_i) * 100
  @user_amount = @amount / 100

  # The order
  @venue = Venue.find(params[:venue])
  @order = JSON.parse(params[:order].to_s) if params[:order]

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

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => @venue,
    :currency    => 'usd',
    :customer    => @stripe_customer.id
  )

=begin
  # Write order to database
  if Venue.exists?(:handle => params['venue'])
    session[:venue] = params['venue']
    @venue = Venue.find_by_handle(params['venue'])
    session[:phone] = params[:splat].first
    if session[:venue] && session[:phone]
      erb :checkin
    else
      erb "Something has gone awry. The napkin isn't saving the venue properly, please try again."
    end 
  else
    erb "We can't find that venue, please text the proper venue handle(no spaces like a twitter username)"
  end
=end

  # Print the order
  if @order
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