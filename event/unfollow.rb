module Event
  class Unfollow < Base
    attr_reader :from_user_id, :to_user_id

    def initialize(sequence_index, payload, user_repository, from_user_id, to_user_id)
      super(sequence_index, payload, user_repository)
      @from_user_id = from_user_id
      @to_user_id = to_user_id
    end

    def recipient_ids(all_client_ids)
      []
    end

    def run_callbacks
      user = @user_repository.find_or_create(@to_user_id)
      user.remove_follower(@from_user_id)
    end
  end
end
