class UserClient
  attr_reader :id

  def initialize(socket)
    @id = socket.gets.chomp
    @socket = socket
  end
end
