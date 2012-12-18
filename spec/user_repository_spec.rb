require './follower_maze/user_repository'

describe FollowerMaze::UserRepository do
  it "returns user by id" do
    user = subject.find_or_create(1)
    user.should be_a FollowerMaze::User
    user.id.should == 1
  end
end
