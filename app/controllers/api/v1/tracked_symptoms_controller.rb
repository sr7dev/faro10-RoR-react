class Api::V1::TrackedSymptomsController < Api::Controller
  # GET /api/v1/tracked_symptoms
  def index
    @symptoms = current_user.tracked_symptom_symptoms.order(:name)
    @symptoms.each{|symptom| authorize! :read, symptom}
    respond_with @symptoms, each_serializer: SymptomSerializer, root: "symptoms"
  end

  # PUT /api/v1/tracked_symptoms
  def update
    if current_user.tracked_symptom_symptoms = Symptom.find(params[:symptom_ids])
      @symptoms = current_user.tracked_symptom_symptoms.order(:name)
      @symptoms.each{|symptom| authorize! :read, symptom}
      respond_with @symptoms, each_serializer: SymptomSerializer, root: "symptoms"
    else
      render status: 400, json: { errors: "Could not set Symptoms" }
    end
  end
end
