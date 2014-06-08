post '/webhook/print/url' do
  # Retrieve the request's body and parse it as JSON
  @event_json = JSON.parse(request.body.read)

  # Do something with event_json
  puts @event_json
end