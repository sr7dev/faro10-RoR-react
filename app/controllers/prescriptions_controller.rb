class PrescriptionsController < ApplicationController
  # GET /prescriptions
  # GET /prescriptions.json
  def index
    @prescription = Prescription.new
    @prescriptions = current_user.prescriptions
    @current_prescriptions = @prescriptions.current

    @unexpired = current_user.prescriptions.unexpired
    @expired = current_user.prescriptions.expired.reverse

    @entries_prescriptions = current_user.entries_prescriptions

    @supposed_to_take = @prescriptions.sum('reminder')

    @drugs = Drug.all.sort_by &:friendly_name
    @reminders = [["Hourly", 1],
                  ["Daily", 24],
                  ["Twice a Day", 12]]

    grouped_eps = @entries_prescriptions.group('date(entries_prescriptions.day_taken)')

    @series = []

    @current_prescriptions.each do |prescription|
      series_name = "#{prescription.drug.friendly_name} (#{prescription.dosage}mg)"
      prescription_hash = {name: series_name, data: {}}

      grouped_eps = prescription.entries_prescriptions.group('date(entries_prescriptions.day_taken)')
      meds_taken = grouped_eps.sum(:times_taken).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]}

      prescription_hash["data"] = meds_taken

      @series << prescription_hash
    end

    @results = {
      series: @series
    }

    respond_to do |format|
      format.html
      format.json { render status: :ok, json: @results }
    end
  end

  # GET /prescriptions/1
  # GET /prescriptions/1.json
  def show
    @prescription = Prescription.find(params[:id])
    authorize! :read, @prescription
  end

  # GET /prescriptions/new
  def new
    authorize! :create, Prescription
    @prescription = Prescription.new(params[current_user])
  end

  # GET /prescriptions/1/edit
  def edit
    # @prescription = Prescription.edit(params[:id])
    @prescriptions = current_user.prescriptions
    @prescription = Prescription.find(params[:id])
    authorize! :update, @prescription
  end

  # PATCH/PUT /prescriptions/1
  # PATCH/PUT /prescriptions/1.json
  def update
    @prescriptions = current_user.prescriptions
    @prescription = Prescription.find(params[:id])
    authorize! :update, @prescription
    respond_to do |format|
      if @prescription.update_attributes(prescription_params)
        format.html { redirect_to prescriptions_url }
        flash[:success] = "Prescription Updated"
        format.json { render :show, status: :ok, location: @prescription }
      else
        format.html { render :edit }
        format.json { render json: @prescription.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /prescriptions
  # POST /prescriptions.json
  def create
    authorize! :create, Prescription
    @prescription = Prescription.new(prescription_params)
    if @prescription.save
      flash[:success] = "Prescription successfully added!"
      redirect_back fallback_location: root_path
    else
      redirect_back fallback_location: root_path
      errors = []
      @prescription.errors.full_messages.each do |error|
        errors << error
      end
      flash[:danger] = "Failed to create prescription. #{errors.join(", ")}"
    end
  end

  # DELETE /prescriptions/1
  # DELETE /prescriptions/1.json
  def destroy
    @prescription = Prescription.find(params[:id])
    authorize! :destroy, @prescription
    if @prescription.present?
      @prescription.destroy
    end

    respond_to do |format|
      format.html { redirect_to prescriptions_url }
      flash[:success] = "Prescription was successfully deleted."
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prescription
      @prescription = Prescription.find(params[current_user])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prescription_params
      params.require(:prescription).permit(:drug_id, :dosage, :reminder, :started, :ended, :reason, :as_needed).merge(member_id: current_user.id)
    end
end
