class Api::V1::SymptomsController < Api::Controller
  # GET /api/v1/symptoms
  def index
    if current_user
      @symptoms = Symptom.available_to_patient(current_user.id)
    else
      @symptoms = Symptom.default
    end
    respond_with @symptoms.sort_by(&:name), each_serializer: SymptomSerializer, root: "symptoms"
  end

  # POST /api/v1/symptoms
  def create
    authorize! :create, Symptom
    @symptom = Symptom.new(symptom_params.merge(patient_id: current_user.id))

    if @symptom.save
      respond_with @symptom, serializer: SymptomSerializer
    else
      render json: {success: false, errors: @symptom.errors}
    end
  end

  private
    def symptom_params
      params.require(:symptom).permit(:name)
    end
end
