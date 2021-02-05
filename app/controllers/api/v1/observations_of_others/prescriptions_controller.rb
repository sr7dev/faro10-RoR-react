class Api::V1::ObservationsOfOthers::PrescriptionsController < Api::Controller
  def index
    observations = current_user.observations_of_others.
                     active.
                     meds_visible.
                     includes(observee: :prescriptions)
                 
    res = observations.each_with_object({}) do |observation, hash|
      member = observation.observee
      meds   = member.prescriptions.send(type).map do |prescription|
        PrescriptionSerializer.new(prescription).serializable_hash
      end

      hash[member.user_id] = meds
    end

    respond_with res 
  end

  private

  def type
    params[:type] || 'unexpired'
  end
end
