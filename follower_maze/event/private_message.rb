module FollowerMaze
  module Event
    class PrivateMessage < Base
      attr_reader :from_user_id, :to_user_id

      def initialize(sequence_index, payload, user_repository, from_user_id, to_user_id)
        super(sequence_index, payload, user_repository)
        @from_user_id = from_user_id
        @to_user_id = to_user_id
      end

      def recipient_ids(all_client_ids)
        [@to_user_id]
      end
    end
  end
end
