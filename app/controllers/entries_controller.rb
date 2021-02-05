class EntriesController < ApplicationController
  before_action :set_entry, only: [:show, :edit, :update, :destroy]
  around_action :set_time_zone


  # GET /entries
  # GET /entries.json
  def index
    @entries = Entry.all

    if(params[:race])
      @entries = @entries.by_race(params[:race])
    end

    if(params[:gender])
      @entries = @entries.by_gender(params[:gender])
    end

    respond_to do |format|
      format.html
      format.json { render json: @entries, each_serializer: EntrySerializer }
    end
  end

  def analysis
    @entries = Entry.all
  end

  def show
    @entry = Entry.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @entry, serializer: EntrySerializer }
    end
  end

  def new
    authorize! :create, Entry
    @entry = Entry.new(params[current_user])
    current_user.prescriptions.unexpired.includes(:drug).each do |p|
      @entry.entries_prescriptions.build(prescription: p)
    end
    @entry.entries_symptoms.build.build_symptom
  end


  def edit
    # @entry = Entry.update(params[current_user])
  end

  # action to check for journal alerts
  def create
    authorize! :create, Entry
    @entry = current_user.entries.new(entry_params)
    respond_to do |format|
      if @entry.save
        # TODO refactor this to model
        # @entry.check_for_alert or something like
        # prob best in an after_save hook - tim
        if @entry.any_danger?
          @alert = Alert.new(alert_params)
          @alert.member_id = current_user.id
          @alert.alert_type = @entry.alert_type_method
          @alert.alert_body = @entry.alert_body_method
          @alert.save
        end

        flash[:success] = "Entry Updated!"
        format.html { redirect_back fallback_location: root_path }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to @entry, notice: 'Entry was successfully updated.' }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { render :edit }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :destroy, @entry
    @entry.destroy
    respond_to do |format|
      format.html { redirect_to entries_url, notice: 'Entry was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    
  def set_entry
    @entry = Entry.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:updated_at, :created_at, :user_id, :member_id, :feeling, :emotion, :energy, :activity, :anxiety, :headache, :journal, :suicide_thought, :took_meds, :hrs_slept,
    :hrs_slept, :took_meds, :suicide_thought, :zest, :pessimism, :panic_attack, :initiative, :concentration, :appetite, :reported_mood, :restlessness, :dry_mouth, :nausea,
    :nightmare, :pain, :weight, :social_interaction, :hospitalization, :hallucination, :attended_session, :work_life, :social_life, :family_life, :self_harm, :sleep,
    entries_prescriptions_attributes: [entries_prescriptions_attributes], entries_symptoms_attributes: [entries_symptoms_attributes])
  end

  def alert_params
    params.permit(:id, :member_id, :alert_body)
  end

  def entries_prescriptions_attributes
    [:prescription_id, :times_taken, :day_taken, :created_at]
  end

  def entries_symptoms_attributes
    [:symptom_id, symptom_attributes: [symptom_attributes]]
  end

  def symptom_attributes
    [:name, :patient_id]
  end

  def set_time_zone
    Time.use_zone(current_user.time_zone) { yield }
  end

end
