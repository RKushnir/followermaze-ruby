require './follower_maze/user'

describe FollowerMaze::User do
  subject { described_class.new(42) }

  it "adds followers" do
    subject.add_follower(1)
    subject.follower_ids.should include(1)
  end

  it "removes followers" do
    subject.add_follower(1)
    subject.add_follower(2)
    subject.remove_follower(1)
    subject.follower_ids.should_not include(1)
  end
end
