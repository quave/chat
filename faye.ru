require 'faye'
require File.expand_path('../config/initializers/faye_token.rb', __FILE__)

class ServerAuth
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
    puts ''

    if !data.has_key?('ext') || data['ext']['auth_token'] != FAYE_TOKEN
      message['error'] = 'Invalid authentication token'
    end
    
    callback.call(message)
  end
end

Faye::WebSocket.load_adapter('thin')
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
app.on :pubish do |clientId, chan, data|
  puts "Handshake #{clientId}, #{chan}, #{data}"
end
app.on :disconnect do |clientId|
  puts "Disconnect #{clientId}"
end

run app
