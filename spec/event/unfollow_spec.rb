require './follower_maze/event'

describe FollowerMaze::Event::Unfollow do
  let(:followed_user) { mock("followed_user") }
  let(:user_repository) { mock("user_repository") }

  subject { described_class.new(1, "", user_repository, '42', '17') }

  it "returns empty array for recipients" do
    subject.recipient_ids(['1', '2', '3']).should == []
  end

  it "removes user's follower" do
    user_repository.should_receive(:find_or_create).with('17').and_return(followed_user)
    followed_user.should_receive(:remove_follower).with('42')

    subject.run_callbacks
  end
end
