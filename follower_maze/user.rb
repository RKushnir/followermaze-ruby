require 'set'

module FollowerMaze
  class User
    attr_reader :id, :follower_ids

    def initialize(id)
      @id = id
      @follower_ids = Set.new
    end

    def add_follower(follower_id)
      @follower_ids.add(follower_id)
    end

    def remove_follower(follower_id)
      @follower_ids.delete(follower_id)
    end
  end
end
