require './follower_maze/event'

describe FollowerMaze::Event::PrivateMessage do
  subject { described_class.new(1, "", nil, '42', '17') }

  it "returns to_user_id as recipient" do
    subject.recipient_ids(['1', '2', '3']).should == ['17']
  end
end
