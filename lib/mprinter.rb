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