require 'thread'
require './follower_maze/app_logger'

module FollowerMaze
  class Dispatcher
    UserClient = Struct.new(:id, :socket)

    class UserClientsMap
      def initialize
        @map = {}
        @lock = Mutex.new
      end

      def add(id, client)
        @lock.synchronize { @map[id] = client }
      end

      def remove(user_id)
        @lock.synchronize { @map.delete(user_id) }
      end

      def fetch(user_id)
        @lock.synchronize { @map.fetch(user_id) }
      end

      def ids
        @lock.synchronize { @map.keys }
      end

      def clear
        @lock.synchronize do
          clients, @map = @map, {}
          clients
        end
      end
    end

    def initialize
      @user_clients = UserClientsMap.new
    end

    def client_connected(socket)
      user_id = socket.gets.chomp
      @user_clients.add(user_id, UserClient.new(user_id, socket))

      log_info("Client connected: %d" % user_id)
    end

    def event_received(event)
      event.run_callbacks

      event_recipient_ids(event).each do |user_id|
        notify_client(user_id, event)
      end

      log_info("Event processed: %s" % event.payload.inspect)
    end

    def disconnect_all
      clients = @user_clients.clear
      clients.each {|id, client| client.socket.close }
    end

    private

    def event_recipient_ids(event)
      connected_client_ids = @user_clients.ids
      event.recipient_ids(connected_client_ids) & connected_client_ids
    end

    def notify_client(user_id, event)
      client = @user_clients.fetch(user_id)
      client.socket.write(event.payload)
    rescue IOError # client disconnected
      @user_clients.remove(user_id)
      log_info("Client disconnected: %d" % user_id)
    end
  end
end
