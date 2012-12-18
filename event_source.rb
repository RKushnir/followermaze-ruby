require './app_logger'
require './event'

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
        payload.chomp!
        log_info("Event payload received: %s" % payload)
        new_event = @event_builder.call(payload, @user_repository)

        # ignore events with non-positive or duplicated sequence indices
        if new_event.sequence_index > @last_sequence_index
          store_event(new_event)
          process_events(&block)
        else
          log_warn("Invalid event sequence index: %d" % new_event.sequence_index)
        end
      rescue UnrecognizedEventError
        # ignore bad input
        log_warn("Invalid event payload: %s" % payload)
      end
    end
  end

private

  def store_event(event)
    @events << event
    @events.sort_by!(&:sequence_index)
  end

  def process_events(&block)
    while event = next_event
      yield event
    end
  end

  def next_event
    if @events.empty? || @events.first.sequence_index != @last_sequence_index + 1
      return nil
    end

    @last_sequence_index = @events.first.sequence_index
    @events.shift
  end
end
