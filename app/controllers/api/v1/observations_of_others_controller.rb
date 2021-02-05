class Api::V1::ObservationsOfOthersController < Api::Controller
  def index
    respond_with current_user.observations_of_others.active, each_serializer: ObservationSerializer
  end
end
