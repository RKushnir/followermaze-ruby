require 'logger'
require 'singleton'

class AppLogger < Logger
  LOG_FILE = 'server.log'

  include Singleton

  def initialize
    super(LOG_FILE)
  end
end

def log_warn(message)
  AppLogger.instance.warn(message)
end

def log_info(message)
  AppLogger.instance.info(message)
end
