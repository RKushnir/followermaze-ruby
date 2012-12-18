require 'socket'
require './dispatcher'
require './event_source'
require './user_repository'

dispatcher = Dispatcher.new
user_repository = UserRepository.new

Thread.abort_on_exception = true

event_source_thread = Thread.new do
  server = TCPServer.new 9090
  loop do
    begin
      source_socket = server.accept

      event_source = EventSource.new(source_socket, user_repository)
      event_source.each do |event|
        dispatcher.event_received(event)
      end
    ensure
      source_socket.close
    end
  end
end

puts "Event source thread started"

user_client_thread = Thread.new do
  server = TCPServer.new 9099
  begin
    loop { dispatcher.client_connected(server.accept) }
  ensure
    dispatcher.disconnect_all
  end
end

puts "User client thread started"

puts "Press Ctrl+C to interrupt..."

begin
  [event_source_thread, user_client_thread].each(&:join)
rescue Interrupt
  puts "Exiting..."
end
