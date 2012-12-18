require './follower_maze/event'

describe FollowerMaze::Event::Broadcast do
  subject { described_class.new(1, "", nil) }

  it "returns all connected clients as recipients" do
    subject.recipient_ids(['1', '2', '3']).should == ['1', '2', '3']
  end
end
