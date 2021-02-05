class Api::V1::ObservationsOfOthers::EntriesController < Api::Controller
  def index
    res = current_user.observer_entries.includes(observation: :observee).group_by do |observation|
      observation.observee.user_id
    end

    respond_with res
  end
end
