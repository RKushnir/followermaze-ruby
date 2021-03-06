module FollowerMaze
  module Event
    class Follow < Base
      attr_reader :from_user_id, :to_user_id

      def initialize(sequence_index, payload, user_repository, from_user_id, to_user_id)
        super(sequence_index, payload, user_repository)
        @from_user_id = from_user_id
        @to_user_id = to_user_id
      end

      def recipient_ids(all_client_ids)
        [@to_user_id]
      end

      # A pub/sub pattern would be appropriate here. But we need the
      # +user_repository+ for +StatusUpdate+ event anyway, so just leaving it simple.
      def run_callbacks
        user = @user_repository.find_or_create(@to_user_id)
        user.add_follower(@from_user_id)
      end
    end
  end
end
