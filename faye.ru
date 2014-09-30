require 'faye'
require File.expand_path('../config/initializers/faye_token.rb', __FILE__)
require File.expand_path("../config/environments/faye_#{ENV['RACK_ENV']}.rb", __FILE__)
require 'net/http'

class ServerAuth
  def initialize
    @http = Net::HTTP.new SRV_ADDRESS, SRV_PORT
  end

  def incoming(message, callback)
    puts 'Incoming: ' + message.inspect
    
    if message['channel'] =~ %r{^/meta/}
      callback.call(message)
      return
    end
    
    unless message.has_key? 'data'
      message['error'] = 'No data provided'
    end

    data = message['data']

    if message['channel'] == '/in'
      room_id, user_id = data['message'].split('|')
      puts message.inspect
      res = @http.post SRV_PATH,
        "online[id]=#{message['clientId']}&online[room_id]=#{room_id}&online[user_id=#{user_id}"
      puts res.inspect
      return
    end

    if !data.has_key?('ext') || data['ext']['auth_token'] != FAYE_TOKEN
      message['error'] = 'Invalid authentication token'
    end
    
    callback.call(message)
  end
end

Faye::WebSocket.load_adapter('puma')
app = Faye::RackAdapter.new(:mount => '/faye', :timeout => 45)
app.add_extension(ServerAuth.new)
# Faye.logger = lambda { |m| puts m }

app.on :handshake do |clientId|
  puts "Handshake #{clientId}"
end
app.on :subscribe do |clientId, chan|
  puts "Subscribe #{clientId}, #{chan}"
end
app.on :unsubscribe do |clientId, chan|
  puts "Unsubscribe #{clientId}, #{chan}"
end
app.on :publish do |clientId, chan, data|
  puts "Handshake #{clientId}, #{chan}, #{data}"
end
app.on :disconnect do |clientId|
  puts "Disconnect #{clientId}"
end

run app
