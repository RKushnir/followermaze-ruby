require './follower_maze/user'

module FollowerMaze
  class UserRepository
    def initialize
      @users = Hash.new {|users, id| users[id] = User.new(id) }
    end

    def find_or_create(user_id)
      @users[user_id]
    end
  end
end
