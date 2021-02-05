class SymptomsController < ApplicationController
  before_action :set_symptom, only: [:show, :edit, :update, :destroy, :add_tracked, :remove_tracked]

  # GET /symptoms
  # GET /symptoms.json
  def index
    @symptoms = Symptom.all
  end

  # GET /symptoms/1
  # GET /symptoms/1.json
  def show
  end

  # GET /symptoms/new
  def new
    @symptom = Symptom.new
  end

  # GET /symptoms/1/edit
  def edit
  end

  # POST /symptoms
  # POST /symptoms.json
  def create
    @symptom = Symptom.new(symptom_params)

    respond_to do |format|
      if @symptom.save
        current_user.tracked_symptoms.create(symptom: @symptom)
        flash[:success] = 'Symptom was successfully created.'
        format.html { redirect_back fallback_location: root_path }
      else
        flash[:danger] = 'Symptom could not be created.'
        format.html { redirect_back fallback_location: root_path }
      end
    end
  end

  # PATCH/PUT /symptoms/1
  # PATCH/PUT /symptoms/1.json
  def update
    respond_to do |format|
      if @symptom.update(symptom_params)
        format.html { redirect_to @symptom, notice: 'Symptom was successfully updated.' }
        format.json { render :show, status: :ok, location: @symptom }
      else
        format.html { render :edit }
        format.json { render json: @symptom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /symptoms/1
  # DELETE /symptoms/1.json
  def destroy
    @symptom.destroy
    respond_to do |format|
      format.html { redirect_to symptoms_url, notice: 'Symptom was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def tracked
    @available_symptoms = params[:available_symptoms]
    @selected_symptoms = params[:selected_symptoms]

    if @available_symptoms
      @available_symptoms.each do |tracked_symptom|
        if tracked_symptom != ""
          @tracked_symptom = current_user.tracked_symptoms.find_by(symptom_id: tracked_symptom)
          if @tracked_symptom
            @tracked_symptom.destroy
          end
        end
      end
    end

    if @selected_symptoms != nil
      @selected_symptoms.each do |tracked_symptom|
        if tracked_symptom != ""
          @tracked_symptom = current_user.tracked_symptoms.new(symptom_id: tracked_symptom)
          @tracked_symptom.save
        end
      end
    end

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
    end
  end

  def add_tracked
  end

  def remove_tracked
    @tracked_symptom = current_user.tracked_symptoms.find_by(symptom: @symptom)

    respond_to do |format|
      if @tracked_symptom
        @tracked_symptom.destroy
        flash[:success] = "Symptom removed from tracking."
        format.html { redirect_back fallback_location: root_path }
      else
        flash[:danger] = "Error removing symptom from tracking"
        format.html { redirect_back fallback_location: root_path }
      end
    end
  end

  private

    def set_symptom
      @symptom = Symptom.find(params[:id])
    end

    def symptom_params
      params.require(:symptom).permit(:patient_id, :name)
    end

    def tracked_symptom_params
      params.require(:tracked_symptom).permit(:symptom_id)
    end
end
