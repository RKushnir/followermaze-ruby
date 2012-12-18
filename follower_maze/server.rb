require 'socket'
require './follower_maze/dispatcher'
require './follower_maze/event_source'
require './follower_maze/user_repository'

module FollowerMaze
  class Server
    def self.run(source_port=9090, clients_port=9099)
      new(source_port, clients_port).run
    end

    def initialize(source_port, clients_port)
      @event_source_port = source_port
      @user_clients_port = clients_port
      @dispatcher = Dispatcher.new
      @user_repository = UserRepository.new
    end

    def run
      Thread.abort_on_exception = true

      event_source_thread = start_event_source_thread(@event_source_port)
      puts "Event source thread started"

      user_clients_thread = start_user_clients_thread(@user_clients_port)
      puts "User clients thread started"

      puts "Press Ctrl+C to interrupt..."

      [event_source_thread, user_clients_thread].each(&:join)
    rescue Interrupt
      puts "Exiting..."
    end

  private

    def start_event_source_thread(port)
      Thread.new do
        server = TCPServer.new port
        loop do
          begin
            source_socket = server.accept

            event_source = EventSource.new(source_socket, @user_repository)
            event_source.each do |event|
              @dispatcher.event_received(event)
            end
          ensure
            source_socket.close
          end
        end
      end
    end

    def start_user_clients_thread(port)
      Thread.new do
        server = TCPServer.new port
        begin
          loop { @dispatcher.client_connected(server.accept) }
        ensure
          @dispatcher.disconnect_all
        end
      end
    end
  end
end
