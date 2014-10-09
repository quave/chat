require 'faye'
require File.expand_path('../config/initializers/faye_token.rb', __FILE__)
require File.expand_path("../config/environments/faye_#{ENV['RACK_ENV']}.rb", __FILE__)
require 'net/http'
require 'logger'

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
      puts "Send online to #{SRV_ADDRESS} #{SRV_PORT}/#{SRV_PATH}/#{message['clientId']}"
      begin
        res = HTTP_CLIENT.post SRV_PATH,
          "id=#{message['clientId']}&user_id=#{user_id}&room_id=#{room_id}"
        puts "Send online res #{res.inspect}"
      rescue Exception => e
        puts "Error #{e.inspect}"
      end
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
Faye.logger = Logger.new(STDOUT)
Faye.logger.level = Faye::Logging::LOG_LEVELS[:warn]
app = Faye::RackAdapter.new(:mount => '/faye', :timeout => 45)
app.add_extension(ServerAuth.new)

app.on :handshake do |client_id|
  puts "Handshake #{client_id}"
end
app.on :subscribe do |client_id, chan|
  puts "Subscribe #{client_id}, #{chan}"
end
app.on :unsubscribe do |client_id, chan|
  puts "Unsubscribe #{client_id}, #{chan}"
end
app.on :publish do |client_id, chan, data|
  puts "Publish #{client_id}, #{chan}, #{data}"
end
app.on :connect do |client_id|
  puts "Connect #{client_id}"
end
app.on :disconnect do |client_id|
  puts "Disconnect #{client_id}"
  puts "Send offline to #{SRV_ADDRESS} #{SRV_PORT}/#{SRV_PATH}/#{client_id}"
  begin
    res = HTTP_CLIENT.delete "#{SRV_PATH}/#{client_id}"
    puts "Send offline res #{res.inspect}"
  rescue Exception => e
    puts "Error #{e.inspect}"
  end
end

run app
