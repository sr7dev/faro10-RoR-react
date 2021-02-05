class DiagnosesController < ApplicationController


  def index
    @diagnoses = Diagnosis.all.where(member_id: current_user.id)
    @diagnosis = Diagnosis.new
    @medical_conditions = MedicalCondition.all
  end

  def show
    @diagnosis = Diagnosis.find(params[:id])
  end


  def edit
    @diagnosis = Diagnosis.find(params[:id])
    authorize! :update, @diagnosis
  end


  def create
    authorize! :create, Diagnosis
    @diagnosis = Diagnosis.new(diagnosis_params)
    if @diagnosis.save
      flash[:success] = "successfully added!"
      redirect_back fallback_location: root_path
    else
      redirect_back fallback_location: root_path
      flash[:danger] = "Please select an option from the list"
    end
  end

  def new
    authorize! :create, Diagnosis
    @diagnosis = Diagnosis.new(diagnosis_params)
  end

  def update
    respond_to do |format|
      if @diagnosis.update(diagnosis_params)
        format.html { redirect_to @diagnosis, notice: 'successfully updated.' }
        format.json { render :show, status: :ok, location: @diagnosis }
      else
        format.html { render :edit }
        format.json { render json: @diagnosis.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @diagnosis = Diagnosis.find(params[:id])
    @diagnosis.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: 'successfully removed.' }
      format.json { head :no_content }
    end
  end

  private

  def diagnosis_params
    # params.require(:dsm_diagnosis).permit(:id, :member_id, :dsm5_id, :icd10_code).merge(member_id: current_user.id)
    params.require(:diagnosis).permit(:id, :member_id, :medical_condition_id)

  end

end

