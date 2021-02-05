class AlertsController < ApplicationController

  def index
    @patient_alerts = []

    for membership in Membership.where(clinician_id: current_user.id).journal_visible?
      Alert.visible_to(membership).each do |alert|
        @patient_alerts << alert
      end
    end

    @patient_alerts = @patient_alerts.sort_by(&:created_at).reverse
  end

  def show
    @alerts = Alert.all
    @alert = Alert.find(params[:id])

    authorize! :read, @alert

    @member = @alert.member_id

    @patients = current_user.members  #ALL PATIENTS
    @patient_alerts = @alerts.where(member_id: @patients)

    @entries = Entry.where(member_id: @member)

    @patient_entry_total = @entries.uniq.count

    @self_harm_total = @entries.where.not(self_harm: [nil, '']).count

    @suicidal_thoughts_count = @entries.sum('suicide_thought', :distinct => true)

    @bad_mood_sum = @entries.where.not("feeling < 5.1").count



    #These work locally, but fail when i push to HEROKU.  I think they don't fully account for null or other conditions that may exist
    # @bad_mood = @entries.where.not('feeling < 5.1')
    # @first_bad_mood = @bad_mood.present? ? @bad_mood.where('created_at').first : 0      ---- This is the specific failing variable in each
    # @first_bad_var = @first_bad_mood.created_at.to_date.strftime("%A, %B %d, %Y  ")

    # @self_harm = @entries.where.not(self_harm: [nil, ''])
    # @first_self_harm = @self_harm.where('created_at').first
    # @first_self_harm_var = @first_self_harm.created_at.to_date.strftime("%A, %B %d, %Y  ")
    #
    # @suicide_thought = @entries.where.not("suicide_thought < 1")
    # @first_suicide_thought = @suicide_thought.where('created_at').first
    # @first_suicide_thought_var = @first_suicide_thought.created_at.to_date.strftime("%A, %B %d, %Y  ")
# ------------------------


  end


  def new
    authorize! :create, Alert
    @alert = Alert.new
  end

  def edit
    @alert = Alert.find(params[:id])
    authorize! :update, @alert
  end

  def update
    authorize! :update, @alert
    respond_to do |format|
      if @alert.update_attributes(alert_params)
        format.html { redirect_to @alert, notice: 'Alert was successfully updated.' }
        format.json { render :show, status: :ok, location: @alert }
      else
        format.html { render :edit }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @alert = Alert.find(params[:id])

    authorize! :destroy, @alert

    if @alert.present?
    @alert.destroy
    end
    respond_to do |format|
      format.html { redirect_to alerts_url, notice: 'Alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def create
    authorize! :create, Alert

    @alert = Alert.new(alert_params)
    @alert.member_id = current_user.id
    @alert.alert_body = "an alert has been identified"
    if @alert.save
      flash[:danger] = "You have a new Member Alert!"
      redirect_to alerts_url
    else
      redirect_to alerts_url
      flash[:danger] = "Failed to create Member Alert"
    end
  end


  private

  def alert_params
    params.require(:alert).permit(:id, :member_id, :alert_body)
  end

end
