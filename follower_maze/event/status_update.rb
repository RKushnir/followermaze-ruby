module FollowerMaze
  module Event
    class StatusUpdate < Base
      attr_reader :from_user_id

      def initialize(sequence_index, payload, user_repository, from_user_id)
        super(sequence_index, payload, user_repository)
        @from_user_id = from_user_id
      end

      def recipient_ids(all_client_ids)
        user = @user_repository.find_or_create(@from_user_id)
        user.follower_ids
      end
    end
  end
end
