require 'logger'
require 'singleton'

module FollowerMaze
  class AppLogger < Logger
    LOG_FILE = 'server.log'

    include Singleton

    def initialize
      super(LOG_FILE)
    end
  end
end

def log_warn(message)
  FollowerMaze::AppLogger.instance.warn(message)
end

def log_info(message)
  FollowerMaze::AppLogger.instance.info(message)
end
