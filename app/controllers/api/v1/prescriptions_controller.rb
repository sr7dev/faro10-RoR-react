class Api::V1::PrescriptionsController < Api::Controller
  def index
    user = Member.find_by(id: params[:observee_id]) || current_user

    prescriptions = user.prescriptions.send(type).map do |prescription|
      PrescriptionSerializer.new(prescription).serializable_hash
    end

    entries_prescriptions = user.entries_prescriptions.past_weeks(weeks)
    grouped_eps = entries_prescriptions.group('date(entries_prescriptions.day_taken)')

    results = {
      prescriptions: prescriptions,
      entries_prescriptions_chart: {
        meds_taken: grouped_eps.sum(:times_taken).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]}
        }
    }

    render json: results, status: :ok
  end

  # POST /prescriptions
  # POST /prescriptions.json
  def create
    authorize! :create, Prescription
    @prescription = Prescription.new(prescription_params)
    if @prescription.save
      respond_with @prescription, serializer: PrescriptionSerializer
      #render json: {success: true, message: "Prescriptions Updated!"}
    else
      render json: {success: false, errors: @prescription.errors}
    end
  end

  # PUT /prescriptions/:id
  def update
    @prescription = Prescription.find(params[:id])
    authorize! :update, @prescription
    if @prescription.update_attributes(prescription_params)
      respond_with @prescription, serializer: PrescriptionSerializer
    else
      render json: {success: false, errors: @prescription.errors}
    end
  end

  private

  def prescription_params
    params.require(:prescription).permit(:drug_id, :dosage, :reminder, :started, :ended, :as_needed, :reason).merge(member_id: current_user.id)
  end

  def type
    params[:type] || 'unexpired'
  end

  def weeks
    params[:weeks] ? params[:weeks].to_i : 2
  end
end
