module Event
  class Base
    attr_reader :sequence_index, :payload

    def initialize(sequence_index, payload, user_repository)
      @sequence_index = sequence_index
      @payload = payload
      @user_repository = user_repository
    end

    def run_callbacks
      # do nothing
    end
  end
end
