require './follower_maze/event'

describe FollowerMaze::Event::StatusUpdate do
  let(:followed_user) { mock("followed_user", follower_ids: ['23', '54']) }
  let(:user_repository) { mock("user_repository") }

  subject { described_class.new(1, "", user_repository, '42') }

  it "returns all followers of from_user_id as recipients" do
    user_repository.should_receive(:find_or_create).with('42').and_return(followed_user)
    subject.recipient_ids(['1', '2', '3']).should == followed_user.follower_ids
  end
end
