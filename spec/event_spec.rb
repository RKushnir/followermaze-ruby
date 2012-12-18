require './follower_maze/event'

describe FollowerMaze::Event do
  it "builds the follow events" do
    follow = described_class.build("666|F|60|50", nil)
    follow.sequence_index.should == 666
    follow.should be_a(FollowerMaze::Event::Follow)
    follow.from_user_id.should == "60"
    follow.to_user_id.should == "50"
  end

  it "builds the unfollow events" do
    unfollow = described_class.build("1|U|12|9", nil)
    unfollow.sequence_index.should == 1
    unfollow.should be_a(FollowerMaze::Event::Unfollow)
    unfollow.from_user_id.should == "12"
    unfollow.to_user_id.should == "9"
  end

  it "builds the broadcast events" do
    broadcast = described_class.build("542532|B", nil)
    broadcast.sequence_index.should == 542532
    broadcast.should be_a(FollowerMaze::Event::Broadcast)
  end

  it "builds the private message events" do
    private_msg = described_class.build("43|P|32|56", nil)
    private_msg.sequence_index.should == 43
    private_msg.should be_a(FollowerMaze::Event::PrivateMessage)
    private_msg.from_user_id.should == "32"
    private_msg.to_user_id.should == "56"
  end

  it "builds the status update events" do
    status_update = described_class.build("634|S|32", nil)
    status_update.sequence_index.should == 634
    status_update.should be_a(FollowerMaze::Event::StatusUpdate)
    status_update.from_user_id.should == "32"
  end

  it "throws when event type is not recognized" do
    expect { described_class.build("1|X", nil) }.to raise_error(FollowerMaze::UnrecognizedEventError)
  end
end
