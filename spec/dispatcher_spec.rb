require './follower_maze/dispatcher'

describe FollowerMaze::Dispatcher do
  it "sends events to appropriate clients" do
    event = double("event", payload: "hello", run_callbacks: nil)
    related_client = double("related client", gets: "42\r\n")
    non_related_client = double("non related client", gets: "11\r\n")

    event.should_receive(:recipient_ids).with(["42", "11"]).and_return(["42"])
    related_client.should_receive(:puts).with("hello")
    non_related_client.should_not_receive(:puts)

    subject.client_connected(related_client)
    subject.client_connected(non_related_client)
    subject.event_received(event)
  end

  it "disconnects all clients" do
    client1 = double("client1", gets: "42\r\n")
    client2 = double("client2", gets: "11\r\n")

    client1.should_receive(:close)
    client2.should_receive(:close)

    subject.client_connected(client1)
    subject.client_connected(client2)
    subject.disconnect_all
  end
end
