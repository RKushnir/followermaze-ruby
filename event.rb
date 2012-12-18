class UnrecognizedEventError < StandardError
end

module Event
  autoload :Base, './event/base'
  autoload :Follow, './event/follow'
  autoload :Unfollow, './event/unfollow'
  autoload :Broadcast, './event/broadcast'
  autoload :PrivateMessage, './event/private_message'
  autoload :StatusUpdate, './event/status_update'

  def self.build(payload, user_repository)
    params = payload.split('|')
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
