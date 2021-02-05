class Api::V1::EntriesController < Api::Controller
      before_action :set_entry, only: [:show]

  # GET /entries
  # GET /entries.json
  def index
    @entries = current_user.entries

    respond_with @entries, each_serializer: EntrySerializer, root: "entries"
  end

  def analysis
    @entries = Entry.all
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
    authorize! :read, @entry
    respond_with @entry
  end

  def create
    authorize! :create, Entry
    @entry = Entry.new(entry_params)
    @entry.member_id = current_user.id

    if @entry.save

      if @entry.any_danger?
        @alert = Alert.new
        @alert.member_id = current_user.id
        @alert.alert_type = @entry.alert_type_method
        @alert.alert_body = @entry.alert_body_method
        @alert.save
      end

      respond_with @entry
    else
      render status: 400, json: { errors: @entry.errors.full_messages }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_entry
    @entry = Entry.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:user_id, :member_id, :feeling, :emotion, :energy, :activity, :anxiety, :headache, :journal, :suicide_thought, :took_meds, :hrs_slept,
                                  :hrs_slept, :took_meds, :suicide_thought, :zest, :pessimism, :panic_attack, :initiative, :concentration, :appetite, :reported_mood, :restlessness, :dry_mouth, :nausea,
                                  :nightmare, :weight, :social_interaction, :hospitalization, :hallucination, :attended_session, :work_life, :social_life, :family_life, :self_harm,
                                  entries_prescriptions_attributes: [entries_prescriptions_attributes], entries_symptoms_attributes: [entries_symptoms_attributes])
  end

  def entries_prescriptions_attributes
    [:prescription_id, :times_taken, :day_taken, :created_at]
  end

  def entries_symptoms_attributes
    [:symptom_id]
  end
end
