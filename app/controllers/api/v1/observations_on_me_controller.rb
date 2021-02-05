class Api::V1::ObservationsOnMeController < Api::Controller
  def index
    res = current_user.observations_on_me.active.each_with_object({}) do |obs, hash|
      hash[obs.observer.user_id] = {
          observer_id: obs.observer_id,
          relationship: obs.relationship,
          meds: obs.meds,
          id: obs.id,
          status: obs.status
      }
    end

    respond_with res
  end

  def create
    authorize! :create, Observation
    observer = Member.find_by(email: observation_params[:observer_email])

    if observer
      observation = Observation.find_or_initialize_by(member_id: current_user.id, observer_id: observer.id)

      case observation_params[:meds]
      when "1"
        guardian_param = true
      when "2"
        guardian_param = false
      else
        guardian_param = false
      end

      observation.update(relationship: observation_params[:relationship], guardian: guardian_param, status: "active")

      render json: { observation: observation }, status: :ok
    else
      render json: {error: "No Member found with email #{observation_params[:observer_email]}"}, status: :unprocessable_entity
    end
  end

  def update
    # This is tricky because the controllers/routes
    # are pretty far from RESTful but it is attempting to mimic
    # a normal RESTful request. The 'resource' here is an 
    # Observation even though the controller/route are called
    # ObservationsOnMe. We use a separate 'strong params' filter
    # because only :meds is allowed to be updated.
    observation = Observation.find(params[:id])

    authorize! :update, observation

    if observation.update(update_params)
      render json: {observation: observation}, status: :ok
    else
      render json: {errors: observation.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def observation_params
    params.require(:observation).permit(:observer_email, :relationship, :guardian, :meds, :id)
  end

  def update_params
    observation_params.permit(:guardian, :meds, :relationship)
  end
end
