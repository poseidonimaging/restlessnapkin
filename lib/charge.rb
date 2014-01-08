post '/charge' do
  # Amount in cents
  @amount = (params[:amount].to_i) * 100
  @user_amount = @amount / 100

  # The order
  @venue = params[:venue]
  @order = JSON.parse(params[:order].to_s) if params[:order]
  @customer_email = params[:stripeEmail]

  @token = Stripe::Token.retrieve(params[:stripeToken])
  @customer_email = @token[:email]

  customer = Stripe::Customer.create(
    :email => @customer_email,
    :card  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :amount      => @amount,
    :description => @venue,
    :currency    => 'usd',
    :customer    => customer.id
  )

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