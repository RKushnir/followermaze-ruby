module FollowerMaze
  class UnrecognizedEventError < StandardError
  end

  module Event
    autoload :Base, './follower_maze/event/base'
    autoload :Follow, './follower_maze/event/follow'
    autoload :Unfollow, './follower_maze/event/unfollow'
    autoload :Broadcast, './follower_maze/event/broadcast'
    autoload :PrivateMessage, './follower_maze/event/private_message'
    autoload :StatusUpdate, './follower_maze/event/status_update'

    def self.build(payload, user_repository)
      params = payload.chomp.split('|')
      sequence_index = params.fetch(0).to_i
      type = params.fetch(1)
      event_class = class_from_type(type)

      event_class.new(sequence_index, payload, user_repository, *params.drop(2))
    end

    def self.class_from_type(type)
      {
        "F" => Follow,
        "U" => Unfollow,
        "B" => Broadcast,
        "P" => PrivateMessage,
        "S" => StatusUpdate
      }.fetch(type) { raise UnrecognizedEventError }
    end
  end
end
