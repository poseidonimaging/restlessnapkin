# The WebHook object should be initialised with a Rack::Request object, therefore it can be used with any Rack server. Here's a Sinatra example:
post '/webhooks' do
  webhook = Pusher::WebHook.new(request)
  if webhook.valid?
    webhook.events.each do |event|
      case event["name"]
      when 'channel_occupied'
        puts "Channel occupied: #{event["channel"]}"
      when 'channel_vacated'
        puts "Channel vacated: #{event["channel"]}"
      end
    end
  else
    status 401
  end
  return
end