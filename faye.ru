require 'faye'
require File.expand_path('../config/initializers/faye_token.rb', __FILE__)
require File.expand_path("../config/environments/faye_#{ENV['RACK_ENV']}.rb", __FILE__)
require 'net/http'
require 'logger'

HTTP_CLIENT = Net::HTTP.new SRV_ADDRESS, SRV_PORT

class NoException < Exception
end

class ServerAuth

  def incoming(message, callback)
    if message['channel'] =~ %r{^/meta/}
      puts 'Meta: ' + message.inspect
      raise NoException
    end

    data = message['data']
    raise Exce.new 'No data provided' if data.nil?

    ext = data['ext']
    raise ArgumentError.new 'Invalid authentication token' if ext.nil? || ext['auth_token'] != FAYE_TOKEN

  rescue NoException
    # ignored
  rescue ArgumentError => e
    message['error'] = e.message
    puts e.inspect

  ensure
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
