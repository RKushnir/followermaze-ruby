require './follower_maze/event_source'

describe FollowerMaze::EventSource do
  let(:socket) do
    double('socket').tap do |s|
      s.stub(:gets).and_return(
        "event 3\r\n",
        "event 1\r\n",
        "event 2\r\n",
        nil
      )
    end
  end

  let(:user_repository) { double("user_repository") }
  let(:event_builder) { double("event builder") }

  subject { described_class.new(socket, user_repository, event_builder) }

  it "returns events in sequential order" do
    event1 = double('event 1', sequence_index: 1)
    event2 = double('event 2', sequence_index: 2)
    event3 = double('event 3', sequence_index: 3)

    event_builder.should_receive(:call).with('event 1', user_repository).and_return(event1)
    event_builder.should_receive(:call).with('event 2', user_repository).and_return(event2)
    event_builder.should_receive(:call).with('event 3', user_repository).and_return(event3)

    subject.take(3).should == [event1, event2, event3]
  end
end
