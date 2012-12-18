require './follower_maze/app_logger'
require './follower_maze/event'

module FollowerMaze
  class EventSource
    include Enumerable

    def initialize(socket, user_repository, event_builder = Event.public_method(:build))
      @socket = socket
      @last_sequence_index = 0
      @events = []
      @event_builder = event_builder
      @user_repository = user_repository
    end

    def each(&block)
      return to_enum unless block_given?

      while payload = @socket.gets
        begin
          log_info("Event payload received: %s" % payload.inspect)
          new_event = @event_builder.call(payload.chomp, @user_repository)

          if store_event(new_event) && next_event?(new_event)
            process_events(&block)
          end
        rescue UnrecognizedEventError
          # ignore bad input
          log_warn("Invalid event payload: %s" % payload.inspect)
        end
      end
    end

  private

    def store_event(event)
      # ignore events with non-positive or duplicated sequence indices
      if event.sequence_index <= @last_sequence_index
        log_warn("Invalid event sequence index: %d" % event.sequence_index)
        return false
      end

      @events << event
      true
    end

    def process_events(&block)
      @events.sort_by!(&:sequence_index)
      while event = next_event
        yield event
      end
    end

    def next_event?(event)
      event.sequence_index == @last_sequence_index + 1
    end

    def next_event
      if @events.empty? || @events.first.sequence_index != @last_sequence_index + 1
        return nil
      end

      @last_sequence_index = @events.first.sequence_index
      @events.shift
    end
  end
end
