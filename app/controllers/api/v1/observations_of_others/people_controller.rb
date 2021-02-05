class Api::V1::ObservationsOfOthers::PeopleController < Api::Controller
  def index
    res = current_user.observations_of_others.active.each_with_object({}) do |obs, hash|
      hash[obs.observee.user_id] = {
        role: obs.guardian ? "Guardian" : "Standard",
        status: obs.status,
        last_entry: obs.last_entry,
        total_entries: obs.total_entries,
        id: obs.id,
        member_id: obs.observee.id
      }
    end

    respond_with res
  end
end
