require 'faye'
require 'eventmachine'

EM.run do
  client = Faye::Client.new 'http://localhost:9292/faye'
  pub = client.publish '/foo', message: 'test rb', ext: {auth_token: '^9Hd_]UG51*N6112FeBx9@5Q07jVDUK9d8k6A94(f2166F298F' }

  client.subscribe('/foo') do |message|
    puts message.inspect
  end
  puts 'hello'
  pub.callback do
    EM.stop_event_loop 
    puts 'sent'
  end

  pub.errback do |e|
    puts e.inspect
    EM.stop_event_loop
  end
end
