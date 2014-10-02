require 'faye'
require File.expand_path('../config/initializers/faye_token.rb', __FILE__)
require File.expand_path("../config/environments/faye_#{ENV['RACK_ENV']}.rb", __FILE__)
require 'net/http'

HTTP_CLIENT = Net::HTTP.new SRV_ADDRESS, SRV_PORT

class ServerAuth
  def incoming(message, callback)

    if message['channel'] =~ %r{^/meta/}
      puts 'Meta: ' + message.inspect
      callback.call(message)
      return
    end
    
    unless message.has_key? 'data'
      puts 'Error: no data'
      message['error'] = 'No data provided'
    end

    data = message['data']

    if message['channel'] == '/in'
      user_id, room_id = data['message'].split('|')
      puts "Send online #{message.inspect}"
      res = HTTP_CLIENT.post SRV_PATH,
        "id=#{message['clientId']}&user_id=#{user_id}&room_id=#{room_id}"
      puts "Send online #{res.inspect}"
      callback.call(message)
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
  puts "Publish #{clientId}, #{chan}, #{data}"
end
app.on :disconnect do |clientId|
  puts "Disconnect #{clientId}"
  res = HTTP_CLIENT.delete "#{SRV_PATH}/#{clientId}"
  puts "Send offline #{res.inspect}"
end

run app
