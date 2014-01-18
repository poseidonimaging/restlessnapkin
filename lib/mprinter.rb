class Mprinter
  attr_accessor :printer_id
  attr_accessor :printer

  MPRINTER_OAUTH_CLIENT = 'Ehfv3Qk44jJiB8bifM3A'
  MPRINTER_OAUTH_SECRET = 'g91EciYab2LdB83eKaRm'
  MPRINTER_OAUTH_URL    = 'http://manage.themprinter.com/api/v1'

  def initialize(printer_id)
    @printer_id = printer_id
    
    client = OAuth2::Client.new(MPRINTER_OAUTH_CLIENT, MPRINTER_OAUTH_SECRET, :site => MPRINTER_OAUTH_URL, :token_url => MPRINTER_OAUTH_URL + '/token')
    client.connection.response :logger
    @printer = client.client_credentials.get_token({ :client_id => MPRINTER_OAUTH_CLIENT, :client_secret => MPRINTER_OAUTH_SECRET })
  end

  def print(html)
    return @printer.post("/api/v1/queue/add/html/#{@printer_id}", :body => { :data => html })
  end
end

get '/mprinter' do
  erb :mprinter
end

get '/mprinter/authorize' do
  RestClient.log = logger

  MPRINTER_OAUTH_CLIENT = 'Ehfv3Qk44jJiB8bifM3A'
  MPRINTER_OAUTH_SECRET = 'g91EciYab2LdB83eKaRm'
  MPRINTER_OAUTH_URL    = 'http://manage.themprinter.com/api/v1'

  client = OAuth2::Client.new(MPRINTER_OAUTH_CLIENT, MPRINTER_OAUTH_SECRET, :site => MPRINTER_OAUTH_URL, :token_url => MPRINTER_OAUTH_URL + '/token')
  token = client.client_credentials.get_token({ :client_id => MPRINTER_OAUTH_CLIENT, :client_secret => MPRINTER_OAUTH_SECRET })
  response = token.get('/api/v1/account')
  session[:mprinter_access_token] = token.token.to_s

  redirect '/mprinter'
end

get '/mprinter/devices' do
  RestClient.log = logger

  MPRINTER_OAUTH_CLIENT = 'Ehfv3Qk44jJiB8bifM3A'
  MPRINTER_OAUTH_SECRET = 'g91EciYab2LdB83eKaRm'
  MPRINTER_OAUTH_URL    = 'http://manage.themprinter.com/api/v1'

  client = OAuth2::Client.new(MPRINTER_OAUTH_CLIENT, MPRINTER_OAUTH_SECRET, :site => MPRINTER_OAUTH_URL, :token_url => MPRINTER_OAUTH_URL + '/token')
  token = client.client_credentials.get_token({ :client_id => MPRINTER_OAUTH_CLIENT, :client_secret => MPRINTER_OAUTH_SECRET })
  response = token.get('/api/v1/devices')

  erb "#{response.body}"
end

get '/mprinter/devices/dockandroll' do
  RestClient.log = logger

  MPRINTER_OAUTH_CLIENT = 'Ehfv3Qk44jJiB8bifM3A'
  MPRINTER_OAUTH_SECRET = 'g91EciYab2LdB83eKaRm'
  MPRINTER_OAUTH_URL    = 'http://manage.themprinter.com/api/v1'

  client = OAuth2::Client.new(MPRINTER_OAUTH_CLIENT, MPRINTER_OAUTH_SECRET, :site => MPRINTER_OAUTH_URL, :token_url => MPRINTER_OAUTH_URL + '/token')
  token = client.client_credentials.get_token({ :client_id => MPRINTER_OAUTH_CLIENT, :client_secret => MPRINTER_OAUTH_SECRET })
  response = token.get('/api/v1/devices/529f7338449aa8a96b00001a', :body => {:status => 'online'})

  erb "#{response.body}"
end

get '/mprinter/add_device' do
  RestClient.log = logger

  MPRINTER_OAUTH_CLIENT = 'Ehfv3Qk44jJiB8bifM3A'
  MPRINTER_OAUTH_SECRET = 'g91EciYab2LdB83eKaRm'
  MPRINTER_OAUTH_URL    = 'http://manage.themprinter.com/api/v1'
  
  client = OAuth2::Client.new(MPRINTER_OAUTH_CLIENT, MPRINTER_OAUTH_SECRET, :site => MPRINTER_OAUTH_URL, :token_url => MPRINTER_OAUTH_URL + '/token')
  client.connection.response :logger
  token = client.client_credentials.get_token({ :client_id => MPRINTER_OAUTH_CLIENT, :client_secret => MPRINTER_OAUTH_SECRET })
  response = token.post('/api/v1/devices', :body => {:serial => 'WBFFXA'})
  
  erb "#{response.body}"
  #puts token.get(MPRINTER_OAUTH_URL + "/devices").response.body.to_s
  #RestClient.post MPRINTER_OAUTH_URL + '/devices', :serial => 'KMHELM', token.headers
end

get '/mprinter/confirm_device' do
  RestClient.log = logger

  MPRINTER_OAUTH_CLIENT = 'Ehfv3Qk44jJiB8bifM3A'
  MPRINTER_OAUTH_SECRET = 'g91EciYab2LdB83eKaRm'
  MPRINTER_OAUTH_URL    = 'http://manage.themprinter.com/api/v1'
  
  client = OAuth2::Client.new(MPRINTER_OAUTH_CLIENT, MPRINTER_OAUTH_SECRET, :site => MPRINTER_OAUTH_URL, :token_url => MPRINTER_OAUTH_URL + '/token')
  client.connection.response :logger
  token = client.client_credentials.get_token({ :client_id => MPRINTER_OAUTH_CLIENT, :client_secret => MPRINTER_OAUTH_SECRET })
  response = token.post('/api/v1/devices/confirm/52dae6f55740830000000024', :body => {:code => 'PPKTTJ'})
  
  erb "#{response.body}"
  #puts token.get(MPRINTER_OAUTH_URL + "/devices").response.body.to_s
  #RestClient.post MPRINTER_OAUTH_URL + '/devices', :serial => 'KMHELM', token.headers
end

get '/mprinter/device/status' do
  RestClient.log = logger

  MPRINTER_OAUTH_CLIENT = 'Ehfv3Qk44jJiB8bifM3A'
  MPRINTER_OAUTH_SECRET = 'g91EciYab2LdB83eKaRm'
  MPRINTER_OAUTH_URL    = 'http://manage.themprinter.com/api/v1'
  
  client = OAuth2::Client.new(MPRINTER_OAUTH_CLIENT, MPRINTER_OAUTH_SECRET, :site => MPRINTER_OAUTH_URL, :token_url => MPRINTER_OAUTH_URL + '/token')
  client.connection.response :logger
  token = client.client_credentials.get_token({ :client_id => MPRINTER_OAUTH_CLIENT, :client_secret => MPRINTER_OAUTH_SECRET })
  response = token.get('/api/v1/devices')
  
  erb "#{response.body}"
  #puts token.get(MPRINTER_OAUTH_URL + "/devices").response.body.to_s
  #RestClient.post MPRINTER_OAUTH_URL + '/devices', :serial => 'KMHELM', token.headers
end

get '/mprinter/device/html' do
  printer = Mprinter.new("52dae6f55740830000000024")
  erb printer.print("<h1>TEST FROM NEW CODE</h1>").body
end