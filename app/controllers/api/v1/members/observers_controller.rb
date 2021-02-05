class Api::V1::Members::ObserversController < Api::Controller
  def create
    @observer = User.find_by_email(params[:email])

    if @observer
      @observation = Observation.inactive.find_or_initialize_by(member_id: current_user.id, observer_id: @observer.id)
      authorize! :update, @observation
      case params[:meds]
      when "1"
        guardian_param = true
      when "2"
        guardian_param = false
      else
        guardian_param = false
      end

      @observation.update(relationship: params[:relationship], guardian: guardian_param, status: "active")

      render json: @observation, status: :created
    else
      render json: { status: :not_found }
    end
  end

  def destroy
    @observation = Observation.find(params[:id])

    if @observation
      authorize! :update, @observation
      @observation.update(status: "inactive")
      render json: { status: :ok }
    else
      render json: { status: :not_found }
    end
  end

  def update
    @observation = Observation.find(params[:id])
    authorize! :update, @observation
    
    case params[:meds]
    when "1"
      guardian_param = true
    when "2"
      guardian_param = false
    else
      guardian_param = false
    end

    if @observation.update_attributes(guardian: guardian_param, relationship: params[:relationship])
      render json: @observation, status: :ok
    else
      render json: @observation.errors, status: :unprocessable_entity
    end
  end

  private
    def observer_params
      params.require(:observation).permit(:email, :relationship, :guardian, :meds)
    end
end

